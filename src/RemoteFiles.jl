module RemoteFiles

using URIParser

import Base: download

export RemoteFile

type RemoteFile
    uri::URI
    file::String
    dir::String
    updates::Symbol
    timeout::Int
    retries::Int
    wait::Int
    failed::Symbol
end

function RemoteFile(uri::URI;
                    file::String="",
                    dir::String=".",
                    updates::Symbol=:never,
                    timeout::Int=0,
                    retries::Int=3,
                    wait::Int=5,
                    failed::Symbol=:error,
                   )
    if isempty(file)
        file = filename(uri)
        if isempty(file)
            error("File name could not be extracted from URI '$uri'. Try setting it manually.")
        end
    end

    RemoteFile(uri, file, dir, updates, timeout, retries, wait, failed)
end
RemoteFile(uri::String; kwargs...) = RemoteFile(URI(uri); kwargs...)

filename(uri::URI) = split(split(uri.path, ';')[1], '/')[end]

include("updates.jl")
include("download.jl")

end # module
