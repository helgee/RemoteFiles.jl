import Base: download
import Dates: unix2datetime, now

"""
    download(rf::RemoteFile;
             quiet::Bool=false,
             verbose::Bool=false,
             force::Bool=false,
             retries::Int=0)

Download `rf`.

- `quiet`: Do not print messages.
- `verbose`: Print all messages.
- `force`: Force download and overwrite existing files.
- `retries`: Override the number of retries in `rf` if `retries != 0`
"""
function download(rf::RemoteFile; kwargs...)
    for (i, backend) in enumerate(BACKENDS)
        try
            if i == 1
                download(backend, rf; kwargs...)
            else
                download(backend, rf; retries=1, kwargs...)
            end
            return
        catch err
            err isa DownloadError && rf.try_backends && continue
            rethrow(err)
        end
    end
    throw(DownloadError("All available backends failed."))
end

function download(backend, rf::RemoteFile; verbose::Bool=false, quiet::Bool=false,
    force::Bool=false, retries::Int=0)
    file = joinpath(rf.dir, rf.file)
    retries = retries != 0 ? retries : rf.retries

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

    !quiet && @info "Downloading file '$(rf.file)' from '$(rf.uri)' with $(nameof(backend))."
    tries = 0
    success = false
    while tries < retries
        tries += 1
        try
            download(backend, string(rf.uri), tempfile, verbose=verbose)
            success = true
        catch err
            if err isa DownloadError
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
            @warn "Download of '$(rf.uri)' failed after $(retries) retries. Local file was not updated."
        elseif rf.failed == :error || (rf.failed == :warn && !isfile(file))
            throw(DownloadError("Download of '$(rf.uri)' failed after $(retries) retries."))
        end
    end
    rm(tempfile, force=true)
end

function samecontent(file1, file2)
    h1 = hash(open(read, file1, "r"))
    h2 = hash(open(read, file2, "r"))
    h1 == h2
end

