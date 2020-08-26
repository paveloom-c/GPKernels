# This file contains a script to convert `*.ipynb` files
# to Markdown files to further transfer to `Documenter`

@info "ConvertScript: converting notebooks to markdown files."

# Get path to the notebooks folder
notebooks_folder_name = "notebooks"
notebooks_folder = normpath(joinpath(@__DIR__, "..", notebooks_folder_name))

# Get paths to notebooks and their (base)names
names = String[]
notebooks = String[]
for (root, dirs, files) in walkdir(notebooks_folder)
    for file in files
       endswith(file, ".ipynb") && push!(notebooks, joinpath(root, file))
    end
end
names = replace.(basename.(notebooks), ".ipynb" => "")

# Get path to the `make.jl` script
make = joinpath(@__DIR__, "make.jl")

# Go to the output directory
generated_folder = joinpath(@__DIR__, "src", "generated")
output_folder = joinpath(generated_folder, notebooks_folder_name)
!isdir(generated_folder) && mkdir(generated_folder)
!isdir(output_folder) && mkdir(output_folder)
cd(output_folder)

for (index, notebook) in enumerate(notebooks)

    # Get the name of the notebook
    name = names[index]

    # Go to the folder of the notebook
    !isdir(name) && mkdir(name)
    cd(name)

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

    open("$md", "w") do io
        lines[1] = meta_block * lines[1]
        print(io, join(lines, '\n'))
    end

end
