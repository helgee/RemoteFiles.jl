if Sys.isunix() && !success(pipeline(`which curl`, DevNull))
    error("curl was not found. Please install curl through your system's package manager.")
end
