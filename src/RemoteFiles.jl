module RemoteFiles

using URIParser

export RemoteFile

type RemoteFile
    uri::URI
    file::String
    dir::String
    updates::Symbol
    retries::Int
    wait::Int
    failed::Symbol
end

function RemoteFile(uri::URI;
                    file::String="",
                    dir::String=".",
                    updates::Symbol=:never,
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

    RemoteFile(uri, file, dir, updates, retries, wait, failed)
end
RemoteFile(uri::String; kwargs...) = RemoteFile(URI(uri); kwargs...)

filename(uri::URI) = split(split(uri.path, ';')[1], '/')[end]

include("updates.jl")
include("download.jl")

end # module
