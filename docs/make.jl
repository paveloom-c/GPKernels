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
        "IDs" => "ids.md",
        "Notebooks" => [
            "$preamble" => pushfirst!(
                map(
                    s -> "$s" => "generated/$notebooks_folder_name/$preamble/$s/$s.md",
                    replace.(
                        basename.(
                            filter(notebook -> count(preamble, notebook) == 1, notebooks)
                        ),
                        ".ipynb" => ""
                    ),
                ),
                "Preamble" => "generated/$notebooks_folder_name/$preamble/$preamble.md",
            )
            for preamble in preambles
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
    devbranch = "notebooks",
)
