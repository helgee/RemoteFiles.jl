import Base: download, nameof
import Downloads

abstract type AbstractBackend end

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

struct Downloader <: AbstractBackend end
nameof(::Downloader) = "Downloads.jl"

"Alias kept so code written against the former HTTP.jl backend keeps working."
const Http = Downloader

const HEADERS = ["User-Agent" => "RemoteFiles.jl/0.5 (+https://github.com/helgee/RemoteFiles.jl)", "Accept" => "*/*"]

function download(::Downloader, url, filename; verbose::Bool=false)
    try
        Downloads.download(url, filename; headers=HEADERS, verbose=verbose)
    catch err
        throw(DownloadError((sprint(showerror, err))))
    end
end
