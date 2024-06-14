#!/bin/bash

# setup.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

## Variables
# dotfiles directory
dir="$HOME/dotfiles"
# old dotfiles backup directory
olddir="$HOME/Documents/dotfiles_old"
# list of files/folders to symlink in homedir

# Ask if user is on server machine or not (if cli arg not provided)
# (only copies necessary server config)
if [ -n "$1" ]; then
    confirmation="$1";
else
    echo "Is this a server machine? (y/n)"
    read -r confirmation
fi

# TODO: make files and directory linking better, possibly with stow
if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    echo "Running in server configuration mode..."
    files="bashrc vimrc zshrc ignore tmux.conf"
    config_directories="nvim nixpkgs nix tmux"
    directories="templates"
else
    echo "Running in laptop/desktop configuration mode..."
    files="bashrc vimrc zshrc xinitrc Xresources ignore tmux.conf lintr Rprofile"
    config_directories="bspwm rofi polybar kitty nvim zathura wezterm tmux nix nixpkgs"
    directories="templates"
fi

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p "$olddir"
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd "$dir" || exit
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv "$HOME/.$file" "$olddir/"
    echo "Creating symlink to $file in home directory."
    ln -s "$dir/$file" "$HOME/.$file"
done
echo "...done"

# symlink configuration files and directories to ~/.config
for directory in $config_directories; do
    echo "Moving any existing dotfiles from ~ to $olddir/config"
    mv "$HOME/.config/$directory" "$olddir/config"
    echo "Creating symlink to $dir in .config"
    ln -s "$dir/config/$directory" "$HOME/.config/"
done

# symlink files and directories to ~/
for directory in $directories; do
    echo "Moving any existing dotfiles from ~ to $olddir/"
    mv "$HOME/$directory" "$olddir/"
    echo "Creating symlink to $dir in ~/"
    ln -s "$dir/$directory" "$HOME/$directory"
done

# special case for symlinking fonts
echo "Creating symlink to $dir/fonts in ~/.local/share/fonts"
mkdir -p "$HOME/.local/share/fonts"
ln -s "$dir/fonts" "$HOME/.local/share/fonts/custom"

# make extra directories
echo "Making common directories..."
mkdir "$HOME/projects"
mkdir "$HOME/work"
mkdir "$HOME/school"

echo "...done"

