__precompile__()

module RemoteFiles

using HTTP: URI

import Base: rm, isfile, getindex, download, rm

export DownloadError, RemoteFile, @RemoteFile, path, rm, isfile,
    RemoteFileSet, @RemoteFileSet, files, paths, download, load

include("backends.jl")

const BACKENDS = AbstractBackend[Http()]

_iscurl(curl) = occursin("libcurl", read(`$curl --version`, String))

function __init__()
    Sys.which("wget") !== nothing && pushfirst!(BACKENDS, Wget())
    curl = Sys.which("curl")
    curl !== nothing && _iscurl(curl) && pushfirst!(BACKENDS, CURL())
end

struct DownloadError <: Exception
    msg::String
end

Base.show(io::IO, ex::DownloadError) = print(io, ex.msg)

struct RemoteFile
    uri::URI
    file::String
    dir::String
    updates::Symbol
    retries::Int
    try_backends::Bool
    wait::Int
    failed::Symbol
end

function getdir(src)
    file = string(src.file)
    file = startswith(file, "REPL") ? "." : file
    file = abspath(dirname(file), "..", "data")
    :($file)
end

function RemoteFile(uri::URI;
    file::String="",
    dir::String=".",
    updates::Symbol=:never,
    retries::Int=3,
    try_backends::Bool=true,
    wait::Int=5,
    failed::Symbol=:error,
)
    isempty(uri.scheme) && throw(ArgumentError("File URI '$uri' does not seem to be valid."))

    if isempty(file)
        file = filename(uri)
        if isempty(file)
            error("File name could not be extracted from URI '$uri'. "
                * "Try setting it manually.")
        end
    end

    RemoteFile(uri, file, abspath(dir), updates, retries, try_backends, wait, failed)
end
RemoteFile(uri::String; kwargs...) = RemoteFile(URI(uri); kwargs...)

filename(uri::URI) = split(split(uri.path, ';')[1], '/')[end]

macro RemoteFile(uri, args...)
    dir = getdir(__source__)
    kw = Expr[]
    found_dir = false
    for arg in args
        if isa(arg, Expr) && arg.head in (:(=), :kw)
            push!(kw, Expr(:kw, arg.args[1], Expr(:escape, arg.args[end])))
            if arg.args[1] == :dir
                found_dir = true
            end
        end
    end
    if !found_dir
        push!(kw, Expr(:kw, :dir, Expr(:escape, dir)))
    end
    :(RemoteFile($(esc(uri)); $(kw...)))
end

"""
    @RemoteFile name url [key=value...]

Assign the `RemoteFile` located at `url` to the variable `name`.

The following keyword arguments are available:
- `file`: Set a different local file name.
- `dir`: The download directory. If `dir` is not set RemoteFiles will create
    a new directory `data` under the root of the current package and save the
    file there.
- `updates` (default: `:never`): Indicates with which frequency the
    remote file is updated. Possible values are:
    - `:never`
    - `:daily`
    - `:monthly`
    - `:yearly`
    - `:mondays`/`:weekly`, `:tuesdays`, etc.
- `retries` (default: 3): How many retries should be attempted.
- `try_backends` (default: `true`): Whether to retry with different backends.
- `wait` (default: 5): How many seconds to wait between retries.
- `failed` (default: `:error`): What to do if the download fails. Either throw
    an exception (`:error`) or display a warning (`:warn`).
"""
macro RemoteFile(name::Symbol, uri, args...)
    dir = getdir(__source__)
    kw = Expr[]
    found_dir = false
    for arg in args
        if isa(arg, Expr) && arg.head in (:(=), :kw)
            push!(kw, Expr(:kw, arg.args[1], Expr(:escape, arg.args[end])))
            if arg.args[1] == :dir
                found_dir = true
            end
        end
    end
    if !found_dir
        push!(kw, Expr(:kw, :dir, Expr(:escape, dir)))
    end
    :($(esc(name)) = RemoteFile($(esc(uri)); $(kw...)))
end

"""
    path(rf::RemoteFile)

Get the local path of `rf`.
"""
path(rf::RemoteFile) = joinpath(rf.dir, rf.file)

"""
    rm(rf::RemoteFile; force=false)

Remove the downloaded file `rf`.
"""
rm(rf::RemoteFile; force=false) = rm(path(rf), force=force)

"""
    isfile(rf::RemoteFile)

Check whether `rf` has been downloaded.
"""
isfile(rf::RemoteFile) = isfile(path(rf))

struct RemoteFileSet
    name::String
    files::Dict{Symbol,RemoteFile}
end

function RemoteFileSet(name; kwargs...)
    files = Dict{Symbol,RemoteFile}()
    for (k,v) in kwargs
        if isa(v, RemoteFile)
            merge!(files, Dict(k=>v))
        end
    end
    RemoteFileSet(name, files)
end

"""
    @RemoteFileSet name description begin
        file1 = @RemoteFile ...
        file2 = @RemoteFile ...
        ...
    end

Collect several `RemoteFile`s in the `RemoteFileSet` saved under `name` with a
`description`.
"""
macro RemoteFileSet(name, description::String, ex)
    if !isa(ex, Expr) && ex.head == :block
        error("@RemoteFileSet must be used on a code block.")
    end
    kw = Expr[]
    for arg in ex.args
        if isa(arg, Expr) && arg.head in (:(=), :kw)
            lhs = arg.args[1]
            rhs = arg.args[2]
            if (isa(rhs, Expr) && rhs.head == :macrocall && rhs.args[1] ==
                Symbol("@RemoteFile"))
                push!(kw, Expr(:kw, lhs, Expr(:escape, rhs)))
            end
        end
    end
    return :($(esc(name)) = RemoteFileSet($description, $(kw...)))
end

"""
    getindex(rfs::RemoteFileSet, key)

Get the `RemoteFile` identified by `key` from `rfs`.
"""
getindex(rfs::RemoteFileSet, key::Symbol) = rfs.files[key]
getindex(rfs::RemoteFileSet, key::String) = rfs.files[Symbol(key)]

"""
    files(rfs::RemoteFileSet)

Get the (unsorted) list of file identifiers from a `RemoteFileSet`.
"""
files(rfs::RemoteFileSet) = collect(values(rfs.files))

"""
    isfile(rfs::RemoteFileSet, file)

Check whether a specific `file` contained in `rfs` has been downloaded.
"""
isfile(rfs::RemoteFileSet, file) = isfile(rfs[file])

"""
    isfile(rfs::RemoteFileSet)

Check whether all files contained in `rfs` have been downloaded.
"""
isfile(rfs::RemoteFileSet) = all(isfile.(files(rfs)))

"""
    rm(rfs::RemoteFileSet, file; force=false)

Remove a specific downloaded `file` contained in `rfs`.
"""
rm(rfs::RemoteFileSet, file; force=false) = rm(rfs[file], force=force)

"""
    rm(rfs::RemoteFileSet; force=false)

Remove all downloaded files contained in `rfs`.
"""
rm(rfs::RemoteFileSet; force=false) = foreach(x->rm(x, force=force), files(rfs))

"""
    path(rfs::RemoteFileSet, file)

Get the path to a specific downloaded `file` contained in `rfs`.
"""
path(rfs::RemoteFileSet, file) = path(rfs[file])

"""
    paths(rfs::RemoteFileSet, files...)

Get the paths to specific downloaded `files` contained in `rfs`.
"""
paths(rfs::RemoteFileSet, files...) = map(x->path(rfs[x]), files)

include("updates.jl")
include("download.jl")

"""
    download(rfs::RemoteFileSet;
        quiet::Bool=false, verbose::Bool=false, force::Bool=false)

Download all files contained in `rfs`.

- `quiet`: Do not print messages.
- `verbose`: Print all messages.
- `force`: Force download and overwrite existing files.
"""
function download(rfs::RemoteFileSet; quiet::Bool=false, verbose::Bool=false, force::Bool=false)
    verbose && @info "Downloading file set '$(rfs.name)'."
    @sync for file in values(rfs.files)
        @async download(file, quiet=verbose, verbose=verbose, force=force)
    end
end

import FileIO: load

"""
    load(rf::RemoteFile)

Load the contents of a remote file, downloading the file if
it has not been done previously, reading the file from disk
and trying to infer the format from filename and/or magic
bytes in the file via [FileIO.jl](https://github.com/JuliaIO/FileIO.jl).
"""
function load(rf::RemoteFile)
    if !isfile(rf)
        download(rf)
    end
    load(path(rf))
end

end # module
