import Base: download, nameof
import HTTP

abstract type AbstractBackend end

struct CURL <: AbstractBackend end
nameof(::CURL) = "cURL"

function download(::CURL, url, filename; verbose::Bool=false)
    curl = Sys.which("curl")
    curl === nothing && error("The `curl` executable was not found.")
    try
        if verbose
            run(`$curl -o $filename -L $url`)
        else
            run(`$curl -s -o $filename -L $url`)
        end
    catch err
        if (isdefined(Base, :ProcessFailedException) &&
            err isa ProcessFailedException) || err isa ErrorException
            throw(DownloadError(sprint(showerror, err)))
        else
            rethrow(err)
        end
    end
end

struct Wget <: AbstractBackend end
nameof(::Wget) = "wget"

function download(::Wget, url, filename; verbose::Bool=false)
    wget = Sys.which("wget")
    wget === nothing && error("The `wget` executable was not found.")
    try
        if verbose
            run(`$wget -O $filename $url`)
        else
            run(`$wget -q -O $filename $url`)
        end
    catch err
        if (isdefined(Base, :ProcessFailedException) &&
            err isa ProcessFailedException) || err isa ErrorException
            throw(DownloadError(sprint(showerror, err)))
        else
            rethrow(err)
        end
    end
end

struct Http <: AbstractBackend end
nameof(::Http) = "HTTP.jl"

const HEADERS = ["User-Agent" => "RemoteFiles.jl/0.3 (+https://github.com/helgee/RemoteFiles.jl)", "Accept" => "*/*"]

function download(::Http, url, filename; verbose::Bool=false)
    try
        if verbose
            HTTP.download(url, filename, HEADERS)
        else
            HTTP.download(url, filename, HEADERS; update_period=typemax(Int))
        end
    catch err
        throw(DownloadError((sprint(showerror, err))))
    end
end
