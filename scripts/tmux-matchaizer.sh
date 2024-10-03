#!/usr/bin/env bash

session_path=$(tmux display-message -p "#{session_path}")

if tmux list-windows -F "#{window_name}" | grep -q "^matcha$"; then
    tmux select-window -t "matcha"
else
    tmux rename-window "matcha"
    matcha
fi
