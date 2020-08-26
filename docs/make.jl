using Documenter # A package to manage documentation

# Convert the Jupyter notebooks to Markdown files
include("convert.jl")

# Create documentation
makedocs(
    # Specify a name for the site
    sitename = "GPKernels",

    # Specify the author
    authors = "Pavel Sobolev.",

    # Specify the pages on the left side
    pages = [
        "Home" => "index.md",
        "Notebooks" => [
            "Kernels" => map(
                s -> "$s" => "generated/$notebooks_folder_name/$s/$s.md", names,
            ),
        ],
    ],

    # Specify a format
    format = Documenter.HTML(
        # A fallback for creating docs locally
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),

    # Disable doctests
    doctest = false,

    # Fail if any error occurred
    strict = true,
)

# Deploy documentation
deploydocs(
    # Specify a repository
    repo = "github.com/paveloom-c/GPKernels.git",

    # Specify a development branch
    devbranch = "notebooks-update",
)
