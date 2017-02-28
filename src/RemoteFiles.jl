module RemoteFiles

using HTTP
using URIParser

import Base: download

export RemoteFile

type RemoteFile
    uri::URI
    file::String
    updates::Symbol
    timeout::Int
    retries::Int
    required::Bool
    failed::Symbol
end

function RemoteFile(uri::URI;
                    file::String="",
                    updates::Symbol=:never,
                    timeout::Int=0,
                    retries::Int=3,
                    required::Bool=true,
                    failed::Symbol=:error,
                   )
    if isempty(file)
        file = filename(uri)
    end

    if updates != :never
    end

    RemoteFile(uri, file, updates, timeout, retries, required, failed)
end
RemoteFile(uri::String; kwargs...) = RemoteFile(URI(uri); kwargs...)

function download(rf::RemoteFile; verbose::Bool=false)
    tries = 1
    while tries < rf.retries
        try
        catch err
        end
    end
end

filename(uri::URI) = split(split(uri.path, ';')[1], '/')[end]

end # module
