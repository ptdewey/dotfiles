#!/usr/bin/env bash

set -e

pushd ~/dotfiles/config/home-manager

git add home.nix flake.nix flake.lock

echo "Updating home-manager packages..."

nix flake update

popd
