import Dates
using Downloads: RequestError, request

import Base: download, nameof
import HTTP

abstract type AbstractBackend end

struct DownloadsJL <: AbstractBackend end
nameof(::DownloadsJL) = "Downloads.jl"

const HTTP_FMT = Dates.dateformat"eee, dd UUU yyyy HH:MM:SS G\MT"

function download(::DownloadsJL, url, filename; verbose::Bool=false)
    headers = Dict{String, String}()
    if isfile(filename)
        last_modified = Dates.unix2datetime(stat(filename).mtime)
        push!(headers, "if-modified-since"=>Dates.format(last_modified, HTTP_FMT))
    end
    try
        resp = request(url; output=filename, headers, verbose)
        if !(resp.status in (200, 304))
            throw(DownloadError(resp.message))
        end
    catch err
        err isa RequestError && throw(DownloadError(sprint(showerror, err)))
        rethrow(err)
    end
    return nothing
end

struct CURL <: AbstractBackend end
nameof(::CURL) = "cURL"

function download(::CURL, url, filename; verbose::Bool=false)
    curl = Sys.which("curl")
    curl === nothing && error("The `curl` executable was not found.")
    time = isfile(filename)
    cmd = `$curl -s -R -o $filename -L $url`
    time_cmd = `$curl -s -R -z $filename -o $filename -L $url`
    verb_cmd = `$curl -R -o $filename -L $url`
    verb_time_cmd = `$curl -R -z $filename -o $filename -L $url`
    try
        if verbose && time
            run(verb_time_cmd)
        elseif time
            run(time_cmd)
        elseif verbose
            run(verb_cmd)
        else
            run(cmd)
        end
    catch err
        if (isdefined(Base, :ProcessFailedException) &&
            err isa ProcessFailedException) || err isa ErrorException
            throw(DownloadError(sprint(showerror, err)))
        else
            rethrow(err)
        end
    end
    return nothing
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
    return nothing
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
    return nothing
end
