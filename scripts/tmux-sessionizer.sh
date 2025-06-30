#!/usr/bin/env bash
# Inspired by ThePrimeagen

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}

has_session() {
    # if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f "$2/.tmux-sessionizer.sh" ]; then
        tmux send-keys -t "$1" "source $2.tmux-sessionizer.sh;clear" Enter
    elif [ -f "$HOME/.tmux-sessionizer.sh" ]; then
        tmux send-keys -t "$1" "source $HOME/.tmux-sessionizer.sh" Enter
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # use fd instead of find if it exists
    if command -v fd >/dev/null 2>&1; then
        selected=$(
            {
                fd -L . ~/projects ~/workspace --type d --max-depth 1
                # whitelist
                # fd -L . ~/Documents ~/notes ~/dotfiles ~/nixos --type d
                # blacklist
                fd -L . ~/ --type d --max-depth 1 --exclude 'go' --exclude 'Downloads' --exclude 'Desktop' --exclude templates --exclude "Applications"
            } | fzf --preview='tree -LF 2 {}'
        )
    else
        selected=$(
            {
                find ~/projects ~/workspace -mindepth 1 -maxdepth 1 -type d
                find ~/notes -mindepth 1 -maxdepth 2 -type d
                # whitelist
                # find ~/Documents ~/Downloads ~/dotfiles ~/nixos -mindepth 0 -maxdepth 1 -type d
                # blacklist
                find ~ -mindepth 1 -maxdepth 1 -type d ! -name 'Downloads' ! -name 'Desktop' ! -name 'go' ! -name 'templates' ! -name 'Applications'
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
    hydrate "$selected_name" "$selected"
    exit 0
fi

# if ! tmux has-session -t="$selected_name" 2> /dev/null; then
if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    hydrate "$selected_name" "$selected"
fi

switch_to "$selected_name"
