#!/usr/bin/env bash

# Get the current pane's working directory
current_dir=$(tmux display-message -p -F "#{pane_current_path}")

# Open a new window in the same directory
tmux new-window -c "$current_dir"
