var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Modules = [RemoteFiles]\nPrivate = false","category":"page"},{"location":"api/#RemoteFiles.RemoteFile-Tuple{URIs.URI}","page":"API","title":"RemoteFiles.RemoteFile","text":"RemoteFile(uri::URI; kwargs...)\n\nCreate a RemoteFile instance with location url.\n\nThe following keyword arguments are available:\n\nfile: Set a different local file name.\ndir: The download directory. If dir is not set RemoteFiles will create   a new directory data in the current directory, i.e. at pwd().\nupdates (default: :never): Indicates with which frequency the   remote file is updated. Possible values are:\n:never\n:daily\n:monthly\n:yearly\n:mondays/:weekly, :tuesdays, etc.\nretries (default: 3): How many retries should be attempted.\ntry_backends (default: true): Whether to retry with different backends.\nwait (default: 5): How many seconds to wait between retries.\nfailed (default: :error): What to do if the download fails. Either throw   an exception (:error) or display a warning (:warn).\n\nNote: the difference to @RemoteFile is that the default directory data is created in pwd() as opposed to a under the root of the current package.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.RemoteFileSet-Tuple{Any}","page":"API","title":"RemoteFiles.RemoteFileSet","text":"RemoteFileSet(\"Some description\",\n              file1 = RemoteFile(...) # or @RemoteFile ...\n              file2 = RemoteFile(...)\n              )\n\nCollect several RemoteFiles in the RemoteFileSet with a description.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.isfile-Tuple{RemoteFileSet,Any}","page":"API","title":"Base.Filesystem.isfile","text":"isfile(rfs::RemoteFileSet, file)\n\nCheck whether a specific file contained in rfs has been downloaded.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.isfile-Tuple{RemoteFileSet}","page":"API","title":"Base.Filesystem.isfile","text":"isfile(rfs::RemoteFileSet)\n\nCheck whether all files contained in rfs have been downloaded.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.isfile-Tuple{RemoteFile}","page":"API","title":"Base.Filesystem.isfile","text":"isfile(rf::RemoteFile)\n\nCheck whether rf has been downloaded.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.rm-Tuple{RemoteFileSet,Any}","page":"API","title":"Base.Filesystem.rm","text":"rm(rfs::RemoteFileSet, file; force=false)\n\nRemove a specific downloaded file contained in rfs.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.rm-Tuple{RemoteFileSet}","page":"API","title":"Base.Filesystem.rm","text":"rm(rfs::RemoteFileSet; force=false)\n\nRemove all downloaded files contained in rfs.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.Filesystem.rm-Tuple{RemoteFile}","page":"API","title":"Base.Filesystem.rm","text":"rm(rf::RemoteFile; force=false)\n\nRemove the downloaded file rf.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.download-Tuple{RemoteFileSet}","page":"API","title":"Base.download","text":"download(rfs::RemoteFileSet;\n    quiet::Bool=false, verbose::Bool=false, force::Bool=false)\n\nDownload all files contained in rfs.\n\nquiet: Do not print messages.\nverbose: Print all messages.\nforce: Force download and overwrite existing files.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.download-Tuple{RemoteFile}","page":"API","title":"Base.download","text":"download(rf::RemoteFile;\n         quiet::Bool=false,\n         verbose::Bool=false,\n         force::Bool=false,\n         retries::Int=0)\n\nDownload rf.\n\nquiet: Do not print messages.\nverbose: Print all messages.\nforce: Force download and overwrite existing files.\nretries: Override the number of retries in rf if retries != 0\n\n\n\n\n\n","category":"method"},{"location":"api/#FileIO.load-Tuple{RemoteFile}","page":"API","title":"FileIO.load","text":"load(rf::RemoteFile)\n\nLoad the contents of a remote file, downloading the file if it has not been done previously, reading the file from disk and trying to infer the format from filename and/or magic bytes in the file via FileIO.jl.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.files-Tuple{RemoteFileSet}","page":"API","title":"RemoteFiles.files","text":"files(rfs::RemoteFileSet)\n\nGet the (unsorted) list of file identifiers from a RemoteFileSet.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.path-Tuple{RemoteFileSet,Any}","page":"API","title":"RemoteFiles.path","text":"path(rfs::RemoteFileSet, file)\n\nGet the path to a specific downloaded file contained in rfs.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.path-Tuple{RemoteFile}","page":"API","title":"RemoteFiles.path","text":"path(rf::RemoteFile)\n\nGet the local path of rf.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.paths-Tuple{RemoteFileSet,Vararg{Any,N} where N}","page":"API","title":"RemoteFiles.paths","text":"paths(rfs::RemoteFileSet, files...)\n\nGet the paths to specific downloaded files contained in rfs.\n\n\n\n\n\n","category":"method"},{"location":"api/#RemoteFiles.@RemoteFile-Tuple{Symbol,Any,Vararg{Any,N} where N}","page":"API","title":"RemoteFiles.@RemoteFile","text":"@RemoteFile name url [key=value...]\n\nAssign the RemoteFile located at url to the variable name.\n\nThe following keyword arguments are available:\n\nfile: Set a different local file name.\ndir: The download directory. If dir is not set RemoteFiles will create   a new directory data under the root of the current package and save the   file there.\nupdates (default: :never): Indicates with which frequency the   remote file is updated. Possible values are:\n:never\n:daily\n:monthly\n:yearly\n:mondays/:weekly, :tuesdays, etc.\nretries (default: 3): How many retries should be attempted.\ntry_backends (default: true): Whether to retry with different backends.\nbackends (default RemoteFiles.BACKENDS): Which backends to try.\nwait (default: 5): How many seconds to wait between retries.\nfailed (default: :error): What to do if the download fails. Either throw   an exception (:error) or display a warning (:warn).\n\n\n\n\n\n","category":"macro"},{"location":"api/#RemoteFiles.@RemoteFileSet-Tuple{Any,String,Any}","page":"API","title":"RemoteFiles.@RemoteFileSet","text":"@RemoteFileSet name description begin\n    file1 = @RemoteFile ...\n    file2 = @RemoteFile ...\n    ...\nend\n\nCollect several RemoteFiles in the RemoteFileSet saved under name with a description.\n\n\n\n\n\n","category":"macro"},{"location":"#RemoteFiles","page":"Home","title":"RemoteFiles","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Download files from the Internet and keep them up-to-date.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package can be installed through Julia's package manager:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pkg.add(\"RemoteFiles\")","category":"page"},{"location":"#Quickstart","page":"Home","title":"Quickstart","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Remote files are declared through the @RemoteFile macro:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using RemoteFiles\n\n@RemoteFile(JULIA_BINARY, \"https://status.julialang.org/download/win64\",\n    file=\"julia-nightly-x64.exe\", updates=:daily)\n\n# Download the file if it is out-of-date\ndownload(JULIA_BINARY)\n\n# Check whether the file has been downloaded\nisfile(JULIA_BINARY)\n\n# Get the path\npath(JULIA_BINARY)","category":"page"},{"location":"","page":"Home","title":"Home","text":"By default the file is downloaded to Pkg.dir(CURRENT_PACKAGE)/data. This can be customized with the dir keyword argument to the @RemoteFile macro.","category":"page"},{"location":"","page":"Home","title":"Home","text":"RemoteFiles can be grouped together in a RemoteFileSet:","category":"page"},{"location":"","page":"Home","title":"Home","text":"@RemoteFileSet BINARIES \"Julia Binaries\" begin\n    win = @RemoteFile \"https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.0-win64.exe\"\n    osx = @RemoteFile \"https://julialang-s3.julialang.org/bin/osx/x64/0.6/julia-0.6.0-osx10.7+.dmg\"\nend\n\n# Download all of them\n\ndownload(BINARIES)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Note that there is also a function-interface with RemoteFile and RemoteFileSet, see their docstrings.","category":"page"},{"location":"","page":"Home","title":"Home","text":"RemoteFiles.jl will try to download files via the cURL command-line tool by default and automatically fall back to use wget or HTTP.jl if the download fails or the respective binaries are not available.","category":"page"},{"location":"#Documentation","page":"Home","title":"Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Continue to the API documentation.","category":"page"}]
}
