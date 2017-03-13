# RemoteFiles

*Download files from the Internet and keep them up-to-date.*

[![Build Status][travis-badge]][travis-url] [![Build status][av-badge]][av-url] [![Coverage Status][coveralls-badge]][coveralls-url] [![codecov.io][codecov-badge]][codecov-url]

## Installation

The package can be installed through Julia's package manager:

```julia
Pkg.add("RemoteFiles")
```

## Usage

```julia
using RemoteFiles

rf = RemoteFile(
    "https://status.julialang.org/download/win64", # The URL of the remote file
    file="julia-nightly-x64.exe",                  # The local file name
    dir=".",                                       # The download directory
    updates=:daily,                                # The update period of the file
    retries=3,                                     # Retry three times if the download fails
    wait=5,                                        # Wait five seconds between retries
    failed=:error,                                 # Throw an exception if the download fails
)
```

[travis-badge]: https://travis-ci.org/helgee/RemoteFiles.jl.svg?branch=master
[travis-url]: https://travis-ci.org/helgee/RemoteFiles.jl
[av-badge]: https://ci.appveyor.com/api/projects/status/nr2fv8tngcru03k0?svg=true
[av-url]: https://ci.appveyor.com/project/helgee/remotefiles-jl
[coveralls-badge]: https://coveralls.io/repos/helgee/RemoteFiles.jl/badge.svg?branch=master&service=github
[coveralls-url]: https://coveralls.io/github/helgee/RemoteFiles.jl?branch=master
[codecov-badge]: http://codecov.io/github/helgee/RemoteFiles.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/helgee/RemoteFiles.jl?branch=master
