using Documenter, RemoteFiles

makedocs(
    format = :html,
    sitename = "RemoteFiles.jl",
    authors = "Helge Eichhorn",
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    julia = "nightly",
    repo = "github.com/helgee/RemoteFiles.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
