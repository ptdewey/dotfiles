#!/bin/bash

# setup.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

## Variables
# dotfiles directory
dir=~/dotfiles
# old dotfiles backup directory
olddir=~/Documents/dotfiles_old
# list of files/folders to symlink in homedir

# Ask if user is on server machine or not
# (only copies necessary server config)
echo "Is this a server machine? (y/n)"
read -r confirmation
if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    echo "Running in server configuration mode..."
    files="bashrc vimrc zshrc ignore tmux.conf fonts"
    config_directories="nvim"
    directories="Templates"
else
    echo "Running in laptop/desktop configuration mode..."
    files="bashrc vimrc zshrc xinitrc Xresources ignore tmux.conf lintr Rprofile fonts"
    config_directories="bspwm rofi polybar kitty nvim"
    directories="Templates"
fi


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

# symlink configuration files and directories to ~/.config
for directory in $config_directories; do
    echo "Moving any existing dotfiles from ~ to $olddir/config"
    mv ~/.config/$directory $olddir/config
    echo "Creating symlink to $dir in .config"
    ln -s $dir/config/$directory ~/.config/
done

# symlink files and directories to ~/
for directory in $directories; do
    echo "Moving any existing dotfiles from ~ to $olddir/"
    mv ~/$directory $olddir/
    echo "Creating symlink to $dir in ~/"
    ln -s $dir/$directory ~/$directory
done
echo "...done"

