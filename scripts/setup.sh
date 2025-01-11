#!/usr/bin/env bash

dots="$HOME/dotfiles"
olddir="$HOME/Documents/dotfiles_old"

# list of files/folders to symlink in homedir
files=$(ls "${dots}/home")
config_directories=$(ls "${dots}/config")

# create dotfiles_old in homedir
echo "Creating ${olddir} for backup of any existing dotfiles in ~"
mkdir -p "${olddir}/config"
echo "...done"

# change to the dotfiles directory
echo "Changing to the ${dots} directory"
cd "${dots}" || exit
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in ${files}; do
    echo "Moving any existing dotfiles from ${HOME} to ${olddir}"
    mv "${HOME}/.${file}" "${olddir}/"
    echo "Creating symlink to ${dots}/home/${file} in ${HOME}"
    ln -s "${dots}/home/${file}" "$HOME/.${file}"
done
echo "...done"

# symlink configuration files and directories to ~/.config
for directory in ${config_directories}; do
    echo "Moving any existing dotfiles from ${HOME} to ${olddir}/config"
    mv "${HOME}/.config/${directory}" "${olddir}/config"
    echo "Creating symlink to ${dots}/config/${directory} in ${HOME}/.config"
    ln -s "${dots}/config/${directory}" "${HOME}/.config"
done

# special case for symlinking fonts
echo "Creating symlink to ${dots}/fonts in ${HOME}/.local/share/fonts"
mkdir -p "${HOME}/.local/share/fonts"
ln -s "${dots}/fonts" "${HOME}/.local/share/fonts/custom"

# make extra directories
echo "Making common directories..."
mkdir "$HOME/projects"
mkdir "$HOME/school"

# TODO: install go programs (and clone git directories)?

echo "...done"

