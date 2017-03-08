import Base: download
import Base.Dates: unix2datetime, now

export lastupdate

if is_windows()
    function download(url::AbstractString, filename::AbstractString, verbose::Bool)
        res = ccall((:URLDownloadToFileW,:urlmon),stdcall,Cuint,
                    (Ptr{Void},Cwstring,Cwstring,Cuint,Ptr{Void}),C_NULL,url,filename,0,C_NULL)
        if res != 0
            error("Download failed.")
        end
    end
else
    function download(url::AbstractString, filename::AbstractString, verbose::Bool)
        if verbose
            run(`curl -o $filename -L $url`)
        else
            run(`curl -s -o $filename -L $url`)
        end
    end
end

"""
    download(rf::RemoteFile; force::Bool=false, quiet::Bool=false, verbose::Bool=false)

Download a `RemoteFile`. 
"""
function download(rf::RemoteFile; verbose::Bool=false, quiet::Bool=false, force::Bool=false)
    file = joinpath(rf.dir, rf.file)

    if isfile(file) && !force
        if !needsupdate(rf)
            !quiet && info("File '$(rf.file)' is up-to-date.")
            return
        end
    end
    tempfile = tempname()

    if !isdir(rf.dir)
        mkpath(rf.dir)
    end

    !quiet && info("Downloading file '$(rf.file)' from '$(rf.uri)'.")
    tries = 0
    success = false
    while tries < rf.retries
        tries += 1
        try
            download(string(rf.uri), tempfile, verbose)
            success = true
        catch err
            if isa(err, ErrorException)
                if !quiet
                    warn("Download failed with error: $(err.msg)")
                    info("Retrying in $(rf.wait) seconds.")
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
                !quiet && info("File '$(rf.file)' has not changed. Update skipped.")
            else
                !quiet && info("File '$(rf.file)' was successfully updated.")
            end
        else
            !quiet && info("File '$(rf.file)' was successfully downloaded.")
        end
        update && mv(tempfile, file, remove_destination=true)
    else
        if rf.failed == :warn && isfile(file)
            warn("Download of '$(rf.uri)' failed after $(rf.retries) retries. "
                * "Local file was not updated.")
        elseif rf.failed == :error || (rf.failed == :warn && !isfile(file))
            error("Download of '$(rf.uri)' failed after $(rf.retries) retries.")
        end
    end
    rm(tempfile, force=true)
end

lastupdate(rf::RemoteFile) = unix2datetime(stat(path(rf)).mtime)

function samecontent(file1, file2)
    h1 = hash(open(read, file1, "r"))
    h2 = hash(open(read, file2, "r"))
    h1 == h2
end
