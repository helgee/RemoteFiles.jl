import Base.Dates: unix2datetime, now

if is_windows()
    function download(uri::URI, filename::AbstractString)
        res = ccall((:URLDownloadToFileW,:urlmon),stdcall,Cuint,
                    (Ptr{Void},Cwstring,Cwstring,Cuint,Ptr{Void}),C_NULL,string(uri),filename,0,C_NULL)
        if res != 0
            error("automatic download failed (error: $res): $uri")
        end
        filename
    end
else
    function download(uri::URI, filename::AbstractString)
        run(`curl -o $filename -L $(string(uri))`)
        filename
    end
end

function download(rf::RemoteFile; verbose::Bool=false)
    file = joinpath(rf.dir, rf.file)

    if isfile(file)
        created = createtime(file)
        dtnow = now()
        if !needsupdate(created, dtnow, rf.updates)
            verbose && info("File '$(rf.file)' is up-to-date.")
            return
        end
    end
    tempfile = tempname()

    if !isdir(rf.dir)
        mkpath(rf.dir)
    end

    verbose && info("Downloading '$(rf.uri)'.")
    tries = 0
    success = false
    while tries < rf.retries
        tries += 1
        try
            download(rf.uri, tempfile)
            success = true
        catch err
            if isa(err, ErrorException)
                if verbose
                    warn("Download failed with error: $(err.msg)")
                    info("Retrying in $(rf.wait) seconds.")
                    sleep(rf.wait)
                end
            else
                rethrow(err)
            end
        end
    end

    if success
        if isfile(file) && verbose
            info("File '$(rf.file)' was successfully updated.")
        elseif verbose
            info("File '$(rf.file)' was successfully downloaded.")
        end
        mv(tempfile, file, remove_destination=true)
    else
        if rf.failed == :warn && isfile(file)
            warn("Download of '$(rf.uri)' failed after $(rf.retries) retries. Local file was not updated.")
        elseif rf.failed == :error || (rf.failed == :warn && !isfile(file))
            error("Download of '$(rf.uri)' failed after $(rf.retries) retries.")
        end
    end
end

createtime(file) = unix2datetime(stat(file).ctime)