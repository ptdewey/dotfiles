#!/usr/bin/env bash

tmux rename-window "fuzzy-queuer"
pushd "${HOME}/projects/spotify-tools" > /dev/null
source "env.sh"
./cmd/fuzzy-queuer/fuzzy-queuer
popd > /dev/null
