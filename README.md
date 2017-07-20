# RemoteFiles

*Download files from the Internet and keep them up-to-date.*

[![Build Status][travis-badge]][travis-url] [![Build status][av-badge]][av-url] [![Coverage Status][coveralls-badge]][coveralls-url] [![codecov.io][codecov-badge]][codecov-url]

## Installation

The package can be installed through Julia's package manager:

```julia
Pkg.add("RemoteFiles")
```

## Usage

Remote files are declared through the `@RemoteFile` macro:

```julia
using RemoteFiles

@RemoteFile(JULIA_BINARY, "https://status.julialang.org/download/win64",
    file="julia-nightly-x64.exe", updates=:daily)
```

The macro accepts the following optional keyword arguments:

* `file`: Set a different local file name.
* `dir`: The download directory. If `dir` is not set RemoteFiles will create a new directory
`data` under the root of the current package and save the file there.
* `updates` (default: `:never`): Indicates with which frequency the
remote file is updated. Possible values are:
    * `:never`
    * `:daily`
    * `:monthly`
    * `:yearly`
    * `:mondays`/`:weekly`, `:tuesdays`, etc.
* `retries` (default: 3): How many retries should be attempted.
* `wait` (default: 5): How many seconds to wait between retries.
* `failed` (default: `:error`): What to do if the download fails. Either throw
an exception (`:error`) or display a warning (`:warn`).

The following functions work on a `RemoteFile`:

* `isfile(REMOTE_FILE)`: Check whether the file has been downloaded.
    ```julia
    julia> isfile(JULIA_BINARY)
    false
    ```
* `download(REMOTE_FILE, quiet=true, verbose=false, force=false)`: Download the file.
    * `quiet`: Do not print messages.
    * `verbose`: Print all messages.
    * `force`: 
    ```julia
    julia> download(JULIA_BINARY)
    INFO: Downloading file 'julia-nightly-x64.exe' from 'https://status.julialang.org/download/win64'.
    julia> isfile(JULIA_BINARY)
    true
    ```
    ```julia
    rm(JULIA_BINARY, force=true)
    ```
`RemoteFile`s can be grouped together in a `RemoteFileSet`.
The code below will create a `RemoteFileSet` under the variable `BINARIES`:
```julia
@RemoteFileSet BINARIES "Julia Binaries" begin
    win = @RemoteFile "https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.0-win64.exe"
    osx = @RemoteFile "https://julialang-s3.julialang.org/bin/osx/x64/0.6/julia-0.6.0-osx10.7+.dmg"
end
```

```julia
download(BINARIES)
files(BINARIES)
file(BINARIES, :win)
isfile(BINARIES, :win)
path(BINARIES, :win)
rm(BINARIES, :win)
```

[travis-badge]: https://travis-ci.org/helgee/RemoteFiles.jl.svg?branch=master
[travis-url]: https://travis-ci.org/helgee/RemoteFiles.jl
[av-badge]: https://ci.appveyor.com/api/projects/status/nr2fv8tngcru03k0?svg=true
[av-url]: https://ci.appveyor.com/project/helgee/remotefiles-jl
[coveralls-badge]: https://coveralls.io/repos/helgee/RemoteFiles.jl/badge.svg?branch=master&service=github
[coveralls-url]: https://coveralls.io/github/helgee/RemoteFiles.jl?branch=master
[codecov-badge]: http://codecov.io/github/helgee/RemoteFiles.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/helgee/RemoteFiles.jl?branch=master
