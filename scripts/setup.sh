#!/bin/bash

# setup.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

# Variables
dir=~/dotfiles # dotfiles directory
olddir=~/Documents/dotfiles_old # old dotfiles backup directory
files="bashrc vimrc vim zshrc xinitrc Xresources"  # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
echo "...done"

# symlink files and directories to ~/.config
directories="bspwm rofi polybar kitty"
for directory in $directories; do
  echo "Moving any existing dotfiles from ~ to $olddir/config"
  mv ~/.config/$directory $olddir/config
  echo "Creating symlink to $dir in .config"
  ln -s $dir/config/$directory ~/.config/
done
echo "...done"

# special case for neovim custom folder
if [ -d ~/.config/nvim/lua/custom ]; then
  mv ~/.config/nvim/lua/custom $olddir
fi
ln -s $dir/config/nvim/custom ~/.config/nvim/lua

