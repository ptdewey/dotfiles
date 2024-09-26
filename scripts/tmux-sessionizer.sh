#!/usr/bin/env bash
# from ThePrimeagen (modified lightly)

tmux-sessionizer() {
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        # use fd instead of find if it exists
        if command -v fd >/dev/null 2>&1; then
            selected=$(fd -L . ~/work ~/projects ~/notes ~/school ~/ --type d --max-depth 1 | fzf --preview='tree -LF 2 {}')
        else
            selected=$(find ~/work ~/projects ~/notes ~/school ~/ -mindepth 1 -maxdepth 1 -type d | fzf --preview='tree -LF 2 {}')
        fi
        fi

        if [[ -z $selected ]]; then
            return 0
        fi

        selected_name=$(basename "$selected" | tr . _)
        tmux_running=$(pgrep tmux)

        if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
            tmux new-session -s "$selected_name" -c "$selected"
            return 0
        fi

        if ! tmux has-session -t="$selected_name" 2> /dev/null; then
            tmux new-session -ds "$selected_name" -c "$selected"
        fi

        if [[ -z $TMUX ]]; then
            tmux attach -t "$selected_name"
        else
            tmux switch-client -t "$selected_name"
        fi
}
