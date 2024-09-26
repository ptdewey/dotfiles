#!/usr/bin/env bash

pushd /tmp

output=$(cd $(nix build nixpkgs#${1} --print-out-paths --no-link) && nix run nixpkgs#eza -- --tree --level 4)

popd

echo "$output"
