# RemoteFiles

*Download files from the Internet and keep them up-to-date.*

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
    win = @RemoteFile "https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.0-win64.exe"
    osx = @RemoteFile "https://julialang-s3.julialang.org/bin/osx/x64/0.6/julia-0.6.0-osx10.7+.dmg"
end

# Download all of them

download(BINARIES)
```

## Documentation

Continue to the [API](@ref) documentation.
