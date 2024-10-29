#!/usr/bin/env bash
# Inspired by ThePrimeagen

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # use fd instead of find if it exists
    if command -v fd >/dev/null 2>&1; then
        selected=$(
        {
            fd -L . ~/work ~/projects ~/school --type d --max-depth 1
            # whitelist
            # fd -L . ~/Documents ~/notes ~/dotfiles ~/nixos --type d --max-depth 1
            # blacklist
            fd -L . ~/ --type d --max-depth 1 --exclude 'go' --exclude 'Downloads' --exclude 'Desktop' --exclude templates
        } | fzf --preview='tree -LF 2 {}'
        )
    else
        selected=$(
        {
            find ~/work ~/projects ~/school -mindepth 1 -maxdepth 1 -type d
            find ~/notes -mindepth 1 -maxdepth 2 -type d
            # whitelist
            # find ~/Documents ~/Downloads -mindepth 1 -maxdepth 1 -type d
            # blacklist
            find ~ -mindepth 1 -maxdepth 1 -type d ! -name 'Downloads' ! -name 'Desktop' ! -name 'go' ! -name 'templates'
        } | fzf --preview='tree -LF 2 {}'
        )
    fi
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z $TMUX ]]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
