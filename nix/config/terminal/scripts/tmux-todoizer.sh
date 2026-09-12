#!/usr/bin/env bash

session_path=$(tmux display-message -p "#{session_path}")

if tmux list-windows -F "#{window_name}" | grep -q "^todo$"; then
    tmux select-window -t "todo"
else
    tmux rename-window "todo"

    if [[ -e "todo.md" ]]; then
        nvim "todo.md"
    elif [[ -e "${session_path}/todo.md" ]]; then
        nvim "${session_path}/todo.md"
    else
        nvim "${HOME}/notes/notes/todo.md"
    fi
fi
