# This file contains a script to convert `*.ipynb` files
# to Markdown files to further transfer to `Documenter`

# Get path to the notebooks folder
notebooks_folder_name = "notebooks"
notebooks_folder = joinpath(@__DIR__, "..", notebooks_folder_name)

# Get paths to notebooks
notebooks = String[]
for (root, dirs, files) in walkdir(notebooks_folder)
    for file in files
       endswith(file, ".ipynb") && push!(notebooks, joinpath(root, file))
    end
end

# Get path to the `make.jl` script
make = joinpath(@__DIR__, "make.jl")

# Create a temporary directory for converted notebooks
!isdir("convert") && mkdir("convert")

cd("convert")

for notebook in notebooks

    # Get the name of the notebook
    name = basename(notebook)

    # Construct the name of a Markdown file
    md = "$name.md"

    # Convert the notebook to a Markdown file
    run(`jupyter nbconvert --to markdown $notebook --output-dir . --output $md`)

    # Get the content of the generated Markdown file
    lines = readlines("$md")

    # Initialize auxiliary variables
    inside_julia_block = false
    inside_output_block = false
    last_index = size(lines, 1)

    # Put the text output in the text block
    for (index, line) in enumerate(lines)

        if startswith(line, "```julia") && !inside_julia_block
            inside_julia_block = true
            if inside_output_block
                lines[index - 1] = "```\n"
                inside_output_block = false
            end
            continue
        elseif startswith(line, "```") && inside_julia_block
            inside_julia_block = false
            continue
        end

        if !inside_output_block && !inside_julia_block  && !isempty(line) #=
        =# && !startswith(line, "![png]") && !startswith(line, "![svg]")
            inside_output_block = true
            lines[index - 1] = "\n```text\n"
            continue
        end

        if inside_output_block && index == last_index
            lines[index] = "\n```text"
        end

    end

    open("test.md", "w") do io
        print(io, join(lines, '\n'))
    end

end
