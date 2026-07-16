using Documenter
using SciMLPublic

makedocs(;
    modules = [SciMLPublic],
    sitename = "SciMLPublic.jl",
    pages = [
        "Home" => "index.md",
    ],
    checkdocs = :exports,
)

deploydocs(; repo = "github.com/SciML/SciMLPublic.jl")
