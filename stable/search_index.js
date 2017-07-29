var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#RemoteFiles-1",
    "page": "Home",
    "title": "RemoteFiles",
    "category": "section",
    "text": "Download files from the Internet and keep them up-to-date."
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "The package can be installed through Julia's package manager:Pkg.add(\"RemoteFiles\")"
},

{
    "location": "index.html#Quickstart-1",
    "page": "Home",
    "title": "Quickstart",
    "category": "section",
    "text": "Remote files are declared through the @RemoteFile macro:using RemoteFiles\n\n@RemoteFile(JULIA_BINARY, \"https://status.julialang.org/download/win64\",\n    file=\"julia-nightly-x64.exe\", updates=:daily)\n\n# Download the file if it is out-of-date\ndownload(JULIA_BINARY)\n\n# Check whether the file has been downloaded\nisfile(JULIA_BINARY)\n\n# Get the path\npath(JULIA_BINARY)By default the file is downloaded to Pkg.dir(CURRENT_PACKAGE)/data. This can be customized with the dir keyword argument to the @RemoteFile macro.RemoteFiles can be grouped together in a RemoteFileSet:@RemoteFileSet BINARIES \"Julia Binaries\" begin\n    win = @RemoteFile \"https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.0-win64.exe\"\n    osx = @RemoteFile \"https://julialang-s3.julialang.org/bin/osx/x64/0.6/julia-0.6.0-osx10.7+.dmg\"\nend\n\n# Download all of them\n\ndownload(BINARIES)"
},

{
    "location": "index.html#Documentation-1",
    "page": "Home",
    "title": "Documentation",
    "category": "section",
    "text": "Continue to the API documentation."
},

{
    "location": "api.html#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": ""
},

{
    "location": "api.html#Base.Filesystem.isfile-Tuple{RemoteFiles.RemoteFileSet,Any}",
    "page": "API",
    "title": "Base.Filesystem.isfile",
    "category": "Method",
    "text": "isfile(rfs::RemoteFileSet, file)\n\nCheck whether a specific file contained in rfs has been downloaded.\n\n\n\n"
},

{
    "location": "api.html#Base.Filesystem.isfile-Tuple{RemoteFiles.RemoteFileSet}",
    "page": "API",
    "title": "Base.Filesystem.isfile",
    "category": "Method",
    "text": "isfile(rfs::RemoteFileSet, file)\n\nCheck whether all files contained in rfs have been downloaded.\n\n\n\n"
},

{
    "location": "api.html#Base.Filesystem.isfile-Tuple{RemoteFiles.RemoteFile}",
    "page": "API",
    "title": "Base.Filesystem.isfile",
    "category": "Method",
    "text": "isfile(rf::RemoteFile)\n\nCheck whether rf has been downloaded.\n\n\n\n"
},

{
    "location": "api.html#Base.Filesystem.rm-Tuple{RemoteFiles.RemoteFileSet,Any}",
    "page": "API",
    "title": "Base.Filesystem.rm",
    "category": "Method",
    "text": "rm(rfs::RemoteFileSet, file; force=false)\n\nRemove a specific downloaded file contained in rfs.\n\n\n\n"
},

{
    "location": "api.html#Base.Filesystem.rm-Tuple{RemoteFiles.RemoteFileSet}",
    "page": "API",
    "title": "Base.Filesystem.rm",
    "category": "Method",
    "text": "rm(rfs::RemoteFileSet; force=false)\n\nRemove all downloaded files contained in rfs.\n\n\n\n"
},

{
    "location": "api.html#Base.Filesystem.rm-Tuple{RemoteFiles.RemoteFile}",
    "page": "API",
    "title": "Base.Filesystem.rm",
    "category": "Method",
    "text": "rm(rf::RemoteFile; force=false)\n\nRemove the downloaded file rf.\n\n\n\n"
},

{
    "location": "api.html#Base.download-Tuple{RemoteFiles.RemoteFileSet}",
    "page": "API",
    "title": "Base.download",
    "category": "Method",
    "text": "download(rfs::RemoteFileSet;\n    quiet::Bool=false, verbose::Bool=false, force::Bool=false)\n\nDownload all files contained in rfs.\n\nquiet: Do not print messages.\nverbose: Print all messages.\nforce: Force download and overwrite existing files.\n\n\n\n"
},

{
    "location": "api.html#Base.download-Tuple{RemoteFiles.RemoteFile}",
    "page": "API",
    "title": "Base.download",
    "category": "Method",
    "text": "download(rf::RemoteFile; quiet::Bool=false, verbose::Bool=false,\n    force::Bool=false)\n\nDownload rf.\n\nquiet: Do not print messages.\nverbose: Print all messages.\nforce: Force download and overwrite existing files.\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.files-Tuple{RemoteFiles.RemoteFileSet}",
    "page": "API",
    "title": "RemoteFiles.files",
    "category": "Method",
    "text": "files(rfs::RemoteFileSet)\n\nGet the (unsorted) list of file identifiers from a RemoteFileSet.\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.path-Tuple{RemoteFiles.RemoteFileSet,Any}",
    "page": "API",
    "title": "RemoteFiles.path",
    "category": "Method",
    "text": "path(rfs::RemoteFileSet, file)\n\nGet the path to a specific downloaded file contained in rfs.\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.path-Tuple{RemoteFiles.RemoteFile}",
    "page": "API",
    "title": "RemoteFiles.path",
    "category": "Method",
    "text": "path(rf::RemoteFile)\n\nGet the local path of rf.\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.paths-Tuple{RemoteFiles.RemoteFileSet,Vararg{Any,N} where N}",
    "page": "API",
    "title": "RemoteFiles.paths",
    "category": "Method",
    "text": "paths(rfs::RemoteFileSet, files...)\n\nGet the paths to specific downloaded files contained in rfs.\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.@RemoteFile-Tuple{Symbol,Any,Vararg{Any,N} where N}",
    "page": "API",
    "title": "RemoteFiles.@RemoteFile",
    "category": "Macro",
    "text": "@RemoteFile name url [key=value...]\n\nAssign the RemoteFile located at url to the variable name.\n\nThe following keyword arguments are available:\n\nfile: Set a different local file name.\ndir: The download directory. If dir is not set RemoteFiles will create   a new directory data under the root of the current package and save the   file there.\nupdates (default: :never): Indicates with which frequency the   remote file is updated. Possible values are:\n:never\n:daily\n:monthly\n:yearly\n:mondays/:weekly, :tuesdays, etc.\nretries (default: 3): How many retries should be attempted.\nwait (default: 5): How many seconds to wait between retries.\nfailed (default: :error): What to do if the download fails. Either throw   an exception (:error) or display a warning (:warn).\n\n\n\n"
},

{
    "location": "api.html#RemoteFiles.@RemoteFileSet-Tuple{Any,String,Any}",
    "page": "API",
    "title": "RemoteFiles.@RemoteFileSet",
    "category": "Macro",
    "text": "@RemoteFileSet name description begin\n    file1 = @RemoteFile ...\n    file2 = @RemoteFile ...\n    ...\nend\n\nCollect several RemoteFiles in the RemoteFileSet saved under name with a description.\n\n\n\n"
},

{
    "location": "api.html#API-1",
    "page": "API",
    "title": "API",
    "category": "section",
    "text": "Modules = [RemoteFiles]\nPrivate = false"
},

]}
