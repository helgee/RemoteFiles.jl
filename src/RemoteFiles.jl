module RemoteFiles

using URIParser

import Base: rm, isfile, getindex, download, rm

export RemoteFile, @RemoteFile, path, rm, isfile, RemoteFileSet, @RemoteFileSet,
    files

type RemoteFile
    uri::URI
    file::String
    dir::String
    updates::Symbol
    retries::Int
    wait::Int
    failed::Symbol
    update_unchanged::Bool
end

function RemoteFile(uri::URI;
    file::String="",
    dir::String=".",
    updates::Symbol=:never,
    retries::Int=3,
    wait::Int=5,
    failed::Symbol=:error,
    update_unchanged::Bool=true,
)
    if isempty(file)
        file = filename(uri)
        if isempty(file)
            error("File name could not be extracted from URI '$uri'. "
                * "Try setting it manually.")
        end
    end

    RemoteFile(uri, file, abspath(dir), updates, retries, wait, failed, update_unchanged)
end
RemoteFile(uri::String; kwargs...) = RemoteFile(URI(uri); kwargs...)

filename(uri::URI) = split(split(uri.path, ';')[1], '/')[end]

macro RemoteFile(uri, args...)
    dir = :(abspath(isa(@__FILE__, Void) ? "." : dirname(@__FILE__), "..", "data"))
    kw = Expr[]
    for arg in args
        if isa(arg, Expr) && arg.head in (:(=), :kw)
            push!(kw, Expr(:kw, arg.args...))
        end
    end
    return :(RemoteFile($(esc(uri)); dir=$(esc(dir)), $(kw...)))
end

path(rf::RemoteFile) = joinpath(rf.dir, rf.file)
rm(rf::RemoteFile; force=false) = rm(path(rf), force=force)
isfile(rf::RemoteFile) = isfile(path(rf))

immutable RemoteFileSet
    files::Dict{Symbol,RemoteFile}
end

function RemoteFileSet(;kwargs...)
    files = Dict{Symbol,RemoteFile}()
    for (k,v) in kwargs
        if isa(v, RemoteFile)
            merge!(files, Dict(k=>v))
        end
    end
    RemoteFileSet(files)
end

macro RemoteFileSet(ex)
    if !isa(ex, Expr) && ex.head == :block
        error("@RemoteFileSet must be used on a code block.")
    end
    kw = Expr[]
    for arg in ex.args
        if isa(arg, Expr) && arg.head in (:(=), :kw)
            lhs = arg.args[1]
            rhs = arg.args[2]
            if (isa(rhs, Expr) && rhs.head == :macrocall
                && rhs.args[1] == Symbol(:@RemoteFile))
                push!(kw, Expr(:kw, lhs, Expr(:escape, rhs)))
            end
        end
    end
    return :(RemoteFileSet($(kw...)))
end

files(rfs::RemoteFileSet) = collect(values(rfs.files))
getindex(rfs::RemoteFileSet, key::Symbol) = rfs.files[key]
getindex(rfs::RemoteFileSet, key::String) = rfs.files[Symbol(key)]
isfile(rfs::RemoteFileSet) = all(isfile.(files(rfs)))
rm(rfs::RemoteFileSet; force=false) = foreach(x->rm(x, force=force), files(rfs))

include("updates.jl")
include("download.jl")

function download(rfs::RemoteFileSet; verbose::Bool=false, force::Bool=false)
    @sync for file in values(rfs.files)
        @async download(file, verbose=verbose, force=force)
    end
end

end # module
