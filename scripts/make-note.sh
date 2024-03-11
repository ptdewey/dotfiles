#!/usr/bin/env bash

# get current folder
dir=`basename $(pwd)`
pdir=`basename "$(dirname "$(pwd)")"`

# Generate filename (lowercase month)
notefile="`date "+%b%d" | tr '[:upper:]' '[:lower:]'`-$dir.md"

# Check if file exists, stop if it does
if [[ -e $notefile ]]; then
    echo "File '$notefile' already exists."
    nvim $notefile
else
    # Create new notes file
    touch $notefile
    echo "Created file '$notefile'."

    # Capitalize dirname if in 'uppercase' list
    uppercase="cs cmda hw"
    for str in $uppercase; do
        # Check if dir should be capitalized
        if [ "$(echo $dir | cut -c-${#str})" == "$str" ]; then
            dir=$(echo "$dir" | sed "s/^${str}/${str^^}/")
        fi
        # Check if parent dir should be capitalized
        if [ "$(echo $pdir | cut -c-${#str})" == "$str" ]; then
            pdir=$(echo "$pdir" | sed "s/^${str}/${str^^}/")
        fi
    done

    # Append header and date to file
    echo "# ${dir^} - ${pdir^}" >> $notefile
    date "+%B %d, %Y" >> $notefile

    nvim $notefile
fi

