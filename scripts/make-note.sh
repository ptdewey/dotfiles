#!/bin/bash

# get current folder
dir=`basename $(pwd)`

# Generate filename
notefile="`date "+%b%d" | tr '[:upper:]' '[:lower:]'`-$dir.md"

# Check if file exists, stop if it does
if [[ -e $notefile ]]; then
    echo "File '$notefile' already exists."
else
    # Create new notes file
    touch $notefile

    echo "Created file '$notefile'."

    # Append directory header and current date to new file
    # echo "# `echo "$dir" | tr '[:lower:]' '[:upper:]'` Notes" >> $notefile
    # TODO: decide whether or not to do uppercasing
    echo "# $dir Notes" >> $notefile
    date "+%B %d, %Y" >> $notefile

    # Open the file in vim
    nvim $notefile
fi

