#!/usr/bin/env bash

# exit immediately on failure
set -e

# set working directory
pushd ~/dotfiles/config/home-manager

# autoformat nix files
# alejandra . >/dev/null

# shows your changes
git diff -U0 *.nix

git add home.nix flake.nix flake.lock

echo "Home-Manager Rebuilding..."

# rebuild, output simplified errors, log trackebacks
home-manager switch --flake . &>hm-switch.log ||
    (cat hm-switch.log | grep --color error && false)

# get current home manager generation metadata
current=$(home-manager generations | head -n 1)

# commit all changes with the generation metadata
git commit -am "Home Manager: $current"

# switch back to previous directory
popd

