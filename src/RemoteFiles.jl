module RemoteFiles

using URIParser

import Base: rm

export RemoteFile, @RemoteFile, path, rm

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
        if isa(arg, Expr) && arg.head == :(=)
            push!(kw, Expr(:kw, arg.args...))
        end
    end
    return :(RemoteFile($(esc(uri)); dir=$(esc(dir)), $(kw...)))
end

path(rf::RemoteFile) = joinpath(rf.dir, rf.file)
rm(rf::RemoteFile; force=false) = rm(path(rf), force=force)

include("updates.jl")
include("download.jl")

end # module
