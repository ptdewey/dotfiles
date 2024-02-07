#!/bin/bash

# Easily create new files from templates

# Set equal to directory containing template files
templates_dir="$HOME/Templates"

# Create new file of specified name and type from template
create_file_template() {
    # Check if two arguments are provided
    if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        echo "Usage: $0 [<filename>] <filetype>"
        return 1
    fi

    if [ $# -eq 1 ]; then
        filename=$(basename "$(pwd)")
        filetype="$1"
    else
        filename="$1"
        filetype="$2"
    fi

    # Get the directory of the script
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if the templates directory exists
    if [ ! -d "$templates_dir" ]; then
        echo "Templates directory not found: $templates_dir"
        return 1
    fi

    # Check if the template file exists
    template_file="$templates_dir/template.$filetype"
    if [ ! -f "$template_file" ]; then
        echo "Template file not found: $template_file"
        return 1
    fi

    # Check if the destination file already exists
    destination_file="./$filename.$filetype"
    if [ -e "$destination_file" ]; then
        echo "File already exists: $destination_file"
        return 1
    fi

    # Copy the template file to the destination
    cp "$template_file" "$destination_file"
    echo "File created: $destination_file"
}


# Add new file template
add_template() {
    # Check if exactly one argument is provided
    if [ $# -ne 1 ]; then
        echo "Usage: add_template_file <target_file>"
        return 1
    fi

    target_file="$1"
    
    # Check if the templates directory exists
    if [ ! -d "$templates_dir" ]; then
        echo "Templates directory not found: $templates_dir"
        return 1
    fi

    # Extract extension of target file
    ext="${target_file##*.}"

    # Check if the target file exists
    if [ ! -f "$target_file" ]; then
        echo "Target file not found: $target_file"
        return 1
    fi

    # Check if template file already exists
    if [ -f "$templates_dir/template.$ext" ]; then
        echo "Template file for '$ext' already exists."
        return 1
    fi

    # Copy the target file to the templates directory as template.<ext>
    cp "$target_file" "$templates_dir/template.$ext"
    echo "Template file added: $templates_dir/template.$ext"
}

