#!/usr/bin/env bash

selected=$(tmux list-sessions | sed "s/: .*//" | fzf --preview 'tmux list-windows -t {}')

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected"
else
    tmux switch-client -t "$selected"
fi
