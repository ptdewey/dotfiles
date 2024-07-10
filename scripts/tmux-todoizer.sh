#!/usr/bin/env bash

session_path=$(tmux display-message -p "#{session_path}")

if [[ -e "TODO.md" ]]; then
    nvim "TODO.md"
elif [[ -e "${session_path}/TODO.md" ]]; then
    nvim "${session_path}/TODO.md"
else
    nvim "${HOME}/notes/todo.md"
fi
