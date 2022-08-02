#!/bin/bash

# backup critical dotfiles and scripts
dir=~/dotfiles
bak=~/Documents/dotfiles_bak

# files to back up
files="bashrc vimrc zshrc xinitrc Xresources"

# backup up files
echo "Changing to the $dir directory"
cd $dir
echo "Done"

for file in $files; do
    echo "Creating copy of $file in $bak..."
    cp $file $bak 
done

# directories to back up
directories="scripts"
for directory in $directories; do
    echo "Creating copy of $directory in $bak..."
    cp -r $directory $bak
done

echo "Done"
