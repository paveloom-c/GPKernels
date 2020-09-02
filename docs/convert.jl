# This file contains a script to convert `*.ipynb` files
# to Markdown files to further transfer to `Documenter`

@info "ConvertScript: converting notebooks to markdown files."

# Get path to the notebooks folder
notebooks_folder_name = "notebooks"
notebooks_folder = normpath(joinpath(@__DIR__, "..", notebooks_folder_name))

# Get paths to notebooks and their (base)names
names = String[]
notebooks = String[]
preambles = String[]
for (root, dirs, files) in walkdir(notebooks_folder)
    for file in files
        if endswith(file, ".ipynb")
            name = replace(basename(file), ".ipynb" => "")
            push!(notebooks, joinpath(root, file))
            push!(names, name)
            contains(name, "KIC") && push!(preambles, name)
        end
    end
end

# Get path to the `make.jl` script
make = joinpath(@__DIR__, "make.jl")

# Determine the Markdown lines sets
md_lines_preamble = Dict{Int, String}(
    [
        1 => """
        Let's add a couple of packages. If you try this out, know that they take up a
        pretty decent amount of memory.
        """,

        2 => """
        Now let's get the data from the
        [Kepler Archive](https://archive.stsci.edu/kepler/data_search/search.php).
        To make it easier, let's use the Python's [`kplr`](https://github.com/dfm/kplr)
        package:
        """,

        3 => """
        It's useful to look at this data, but before that let's make the plots a little
        prettier. It's never harmful.
        """,

        4 => """
        Okay, now all the power of TeX is under our control. Let's make that plot then:
        """,

        5 => """
        These sharp leaps are associated with the inconsistency of observational periods.
        Let's pick one of the quarters:
        """,

        6 => """
        That will be enough. Let's look at the time series:
        """,

        7 => """
        Gaussian processes are cool, of course, but the models they will use will require
        initial values. Some of these have already been identified before (mean and
        variance), but we will also need an estimate of the period. Let's go the classic
        way and make this estimate by determining the peak position on the Lomb-Scargle
        periodogram.
        """,

        8 => """
        Here's another look at it, just with a logarithmic scale:
        """,

        9 => """
        Yeah, close the plot. It's just good practice. This ends the preamble to this
        object, and we can now proceed with tests of different models for Gaussian
        processes. Click on any of the model IDs in the sidebar to continue.
        """,
    ]
)

md_lines_kernel = Dict{Int, String}(
    [
        1 => """
        Let's execute the preamble in the current scope. Text output will go here as a
        brief reminder of the input data.
        """,

        2 => """
        Let's define a function for calculating the negative log marginal likelihood and an
        auxiliary function for unpacking the tuple of parameters. See the `IDs` page on the
        sidebar for decrypting model IDs.
        """,

        3 => """
        Initial values can be quite important in the optimization process, so it is
        advisable to set them well. Fortunately, a small manual selection with creating the
        plot can help in this. Let's try to choose such parameters that a realization
        of the Gaussian process is similar to the original time series.
        """,

        4 => """
        Finally, let's optimize the negative log marginal likelihood function. This process
        can take quite a lot of time (it was likely aborted manually at some point), so the
        output of the optimizer is very large and therefore placed under the spoiler.
        """,
    ]
)

# Go to the output directory
generated_folder = joinpath(@__DIR__, "src", "generated")
output_folder = joinpath(generated_folder, notebooks_folder_name)
!isdir(generated_folder) && mkdir(generated_folder)
!isdir(output_folder) && mkdir(output_folder)
cd(output_folder)

for (index, notebook) in enumerate(notebooks)

    # Get the name of the notebook
    name = names[index]

    # Initialize an empty Markdown lines set
    md_lines = Dict{Int, String}()

    # A flag showing whether current notebook is about a kernel
    about_kernel = false

    # Determine the preamble
    for preamble in preambles
        if name == preamble

            # Create a working directory
            !isdir(name) && mkdir(name)
            cd(name)

            # Choose a Markdown lines set
            md_lines = md_lines_preamble

            break

        elseif count(preamble, notebook) == 1

            # Create a working directory
            !isdir(preamble) && mkdir(preamble)
            cd(preamble)
            !isdir(name) && mkdir(name)
            cd(name)

            # Choose a Markdown lines set
            md_lines = md_lines_kernel

            about_kernel = true

            break

        end
    end

    # Construct the name of a Markdown file
    md = "$name.md"

    # Convert the notebook to a Markdown file
    output_cmd_part = ["--output-dir", ".", "--output", "$md", "--log-level", "WARN"]
    run(`jupyter nbconvert --to markdown $notebook $output_cmd_part`)

    # Get the content of the generated Markdown file
    lines = readlines("$md")

    # Initialize auxiliary variables
    inside_julia_block = false
    inside_output_block = false
    inside_interrupt_exception = false
    last_index = size(lines, 1)

    # Initialize the code block counter
    code_block = 0

    # Put the text output in the text blocks (and more!)
    for (index, line) in enumerate(lines)

        # Condition of being inside an interrupt exception block
        if inside_interrupt_exception && startswith(line, "    ")

            lines[index] = ""

        # Condition of entering a code block
        elseif startswith(line, "```julia") && !inside_julia_block

            code_block += 1

            # Condition of exiting an output block (code block)
            if inside_output_block

                # Condition of placing the end of a spoiler (before a block of code)
                if about_kernel && code_block == 5
                    lines[index - 1] = """
                    ```
                    ```@raw html
                    </details><br>
                    ```
                    """
                else
                    lines[index - 1] = "```\n"
                end

                inside_output_block = false

            end

            # Insert a Markdown line if it is defined for the current cell
            lines[index] = get(md_lines, code_block, "") * '\n' * lines[index]

            inside_interrupt_exception = false
            inside_julia_block = true

        # Condition of exiting a code block
        elseif startswith(line, "```") && inside_julia_block

            inside_julia_block = false

        # Condition of entering a block of interrupt exception
        elseif !inside_interrupt_exception && inside_output_block #=
            =# && line == "    InterruptException:"

            # Condition of placing the end of a spoiler (before an interrupt exception)
            if about_kernel && code_block == 4
                lines[index - 1] = """
                ```
                ```@raw html
                </details><br>
                ```
                """
            else
                lines[index - 1] = "```\n"
            end

            lines[index] = ""

            inside_output_block = false
            inside_interrupt_exception = true

        # Condition of exiting an output block (Markdown line)
        elseif inside_output_block && !isempty(line) && !startswith(line, "    ")

            # Condition of placing the end of a spoiler (before a Markdown line)
            if about_kernel && code_block == 4
                lines[index - 1] = """
                ```
                ```@raw html
                </details><br>
                ```
                """
            else
                lines[index - 1] = "```\n"
            end

            inside_output_block = false

        # Condition of entering an output block
        elseif !inside_output_block && !inside_julia_block && !inside_interrupt_exception #=
            =# && startswith(line, "    ")

            # Condition of placing the start of a spoiler
            if about_kernel && code_block == 4
                lines[index - 1] = """
                ```@raw html
                <details>
                <summary>Optimizer output</summary>
                ```
                ```text
                """
            else
                lines[index - 1] = "\n```text\n"
            end

            inside_output_block = true

        # Condition of getting the last line of the last block of output
        elseif inside_output_block && index == last_index

            lines[index] = "\n```"

        end

    end

    # Construct a meta block to hide the `Edit on GitHub` URL
    meta_block = join(
        [
            "```@meta",
            "EditURL = \"nothing\"",
            "```\n\n",
        ],
        '\n',
    )

    # Write the meta block
    open("$md", "w") do io
        lines[1] = meta_block * lines[1]
        print(io, join(lines, '\n'))
    end

    # Go back to the output folder
    cd(output_folder)

end

# Go back to the current directory
cd(@__DIR__)
