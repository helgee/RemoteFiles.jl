using Documenter, RemoteFiles

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
    ),
    sitename = "RemoteFiles.jl",
    authors = "Helge Eichhorn",
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
    doctest = false,
)

deploydocs(
    repo = "github.com/helgee/RemoteFiles.jl.git",
    target = "build",
)
