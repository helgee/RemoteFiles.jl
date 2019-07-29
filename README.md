# RemoteFiles

*Download files from the Internet and keep them up-to-date.*

[![Build Status][travis-badge]][travis-url] [![Build status][av-badge]][av-url] [![Coverage Status][coveralls-badge]][coveralls-url] [![codecov.io][codecov-badge]][codecov-url] [![Docs Stable][docs-badge-stable]][docs-url-stable] [![Docs Latest][docs-badge-dev]][docs-url-dev]

## Installation

The package can be installed through Julia's package manager:

```julia
Pkg.add("RemoteFiles")
```

## Quickstart

Remote files are declared through the `@RemoteFile` macro:

```julia
using RemoteFiles

@RemoteFile(JULIA_BINARY, "https://status.julialang.org/download/win64",
    file="julia-nightly-x64.exe", updates=:daily)

# Download the file if it is out-of-date
download(JULIA_BINARY)

# Check whether the file has been downloaded
isfile(JULIA_BINARY)

# Get the path
path(JULIA_BINARY)
```

By default the file is downloaded to `Pkg.dir(CURRENT_PACKAGE)/data`.
This can be customized with the `dir` keyword argument to the `@RemoteFile` macro.

`RemoteFile`s can be grouped together in a `RemoteFileSet`:
```julia
@RemoteFileSet BINARIES "Julia Binaries" begin
    win = @RemoteFile "https://julialang-s3.julialang.org/bin/winnt/x64/0.7/julia-0.7.0-win64.exe"
    osx = @RemoteFile "https://julialang-s3.julialang.org/bin/osx/x64/0.7/julia-0.7.0-osx10.7+.dmg"
end

# Download all of them

download(BINARIES)
```

RemoteFiles.jl will try to download files via the [cURL](https://curl.haxx.se/) command-line tool
by default and automatically fall back to use [wget](https://www.gnu.org/software/wget/) or
[HTTP.jl](https://github.com/JuliaWeb/HTTP.jl) if the download fails or the respective binaries
are not available.

## Documentation

Read the [documentation][docs-url-stable].

[travis-badge]: https://travis-ci.org/helgee/RemoteFiles.jl.svg?branch=master
[travis-url]: https://travis-ci.org/helgee/RemoteFiles.jl
[av-badge]: https://ci.appveyor.com/api/projects/status/nr2fv8tngcru03k0?svg=true
[av-url]: https://ci.appveyor.com/project/helgee/remotefiles-jl
[coveralls-badge]: https://coveralls.io/repos/helgee/RemoteFiles.jl/badge.svg?branch=master&service=github
[coveralls-url]: https://coveralls.io/github/helgee/RemoteFiles.jl?branch=master
[codecov-badge]: http://codecov.io/github/helgee/RemoteFiles.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/helgee/RemoteFiles.jl?branch=master
[docs-badge-dev]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-url-dev]: https://helgee.github.io/RemoteFiles.jl/dev/
[docs-badge-stable]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-url-stable]: https://helgee.github.io/RemoteFiles.jl/stable/
