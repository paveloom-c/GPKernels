using Documenter # A package to manage documentation

include()

# Create documentation
makedocs(
    # Specify a name for the site
    sitename = "GPKernels",

    # Specify the author
    authors = "Pavel Sobolev.",

    # Specify the pages on the left side
    pages = [
        "Home" => "index.md",
        "Notebooks" => map(
            s -> "$s" => "notebooks/$s/$s.md",
            [
                "DSS",
            ]
        ),
    ],

    # Specify a format
    format = Documenter.HTML(
        # A fallback for creating docs locally
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),

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
