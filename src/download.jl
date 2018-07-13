import Base: download
import Dates: unix2datetime, now

@static if Sys.iswindows()
    function _download(url::AbstractString, filename::AbstractString,
        verbose::Bool)
        res = ccall((:URLDownloadToFileW, :urlmon), stdcall, Cuint,
                    (Ptr{Cvoid}, Cwstring, Cwstring, Cuint, Ptr{Cvoid}),
                    C_NULL, url, filename, 0, C_NULL)
        if res != 0
            error("Download failed.")
        end
    end
else
    function _download(url::AbstractString, filename::AbstractString,
        verbose::Bool)
        if verbose
            run(`curl -o $filename -L $url`)
        else
            run(`curl -s -o $filename -L $url`)
        end
    end
end

"""
    download(rf::RemoteFile; quiet::Bool=false, verbose::Bool=false,
        force::Bool=false)

Download `rf`.

- `quiet`: Do not print messages.
- `verbose`: Print all messages.
- `force`: Force download and overwrite existing files.
"""
function download(rf::RemoteFile; verbose::Bool=false, quiet::Bool=false,
    force::Bool=false)
    file = joinpath(rf.dir, rf.file)

    if isfile(file) && !force
        if !isoutdated(rf)
            verbose && @info "File '$(rf.file)' is up-to-date."
            return
        end
    end

    tempfile = tempname()

    if !isdir(rf.dir)
        mkpath(rf.dir)
    end

    !quiet && @info "Downloading file '$(rf.file)' from '$(rf.uri)'."
    tries = 0
    success = false
    while tries < rf.retries
        tries += 1
        try
            _download(string(rf.uri), tempfile, verbose)
            success = true
        catch err
            if isa(err, ErrorException)
                if !quiet
                    @warn "Download failed with error: $(err.msg)"
                    @info "Retrying in $(rf.wait) seconds."
                end
                sleep(rf.wait)
            else
                rethrow(err)
            end
        end
    end

    if success
        update = true
        if isfile(file) && !force
            if samecontent(tempfile, file)
                update = false
                verbose && @info "File '$(rf.file)' has not changed. Update skipped."
            else
                verbose && @info "File '$(rf.file)' was successfully updated."
            end
        else
            verbose && @info "File '$(rf.file)' was successfully downloaded."
        end
        update && mv(tempfile, file, force=true)
    else
        if rf.failed == :warn && isfile(file)
            @warn "Download of '$(rf.uri)' failed after $(rf.retries) retries. Local file was not updated."
        elseif rf.failed == :error || (rf.failed == :warn && !isfile(file))
            error("Download of '$(rf.uri)' failed after $(rf.retries) retries.")
        end
    end
    rm(tempfile, force=true)
end

function samecontent(file1, file2)
    h1 = hash(open(read, file1, "r"))
    h2 = hash(open(read, file2, "r"))
    h1 == h2
end
