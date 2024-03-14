#!/usr/bin/env bash
# update home manager packages defined in home.nix

# exit immediately on failure
set -e

# set working directory
pushd ~/dotfiles/config/home-manager

git add home.nix flake.nix flake.lock

echo "Updating home-manager packages..."

# rebuild, output simplified errors, log trackebacks
nix flake update &>hm-update.log ||
    (cat hm-update.log | grep --color error && false)

# TODO: print out updated packages

# switch back to previous directory
popd
