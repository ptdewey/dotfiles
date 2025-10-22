#!/usr/bin/env bash

dots="$HOME/dotfiles/scripts"
shell=$(ps -p $$ -o 'comm=')

# custom sourcing function
source_if_exists() {
    if [ -f "$1" ]; then
        source "$1"
    fi
}

# general
alias c="clear"
if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd'
else
    alias ls="ls --color"
fi
alias ll="ls -lF"
alias la="ls -a"
alias l="ls -F"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# vim
alias vim="nvim"
alias v="vim"
alias vi="vim"

# Alias fdfind (ubuntu package) to fd
if command -v fdfind >/dev/null 2>&1; then
    alias fd="fdfind"
fi

sd() { cd ./$(fd -L . --type d | fzf --preview='tree -LF 2 {}'); }
sdh() { cd $(fd -L . ~/ --type d | fzf --preview='tree -LF 2 {}'); }
gm() {
    branch=$(basename "$(git rev-parse --show-toplevel)")
    toplevel=$(git rev-parse --show-toplevel)
    if pushd "${toplevel}/../${1}"; then
        if git merge "${branch}"; then
            git push
        else
            echo "Merge failed"
            popd
            return 1
        fi
        popd
    else
        echo "Failed to change directory to ${toplevel}/../${1}"
        return 1
    fi
}

alias vdh='vim $(fd . ~/ --type f | fzf --preview "cat {}")'
alias vd='vim -o $(fzf --preview "cat {}")'

alias ytdl='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio" --write-sub --retries 10'

# scripts
source_if_exists "$dots/ssh.sh"
source_if_exists "$dots/server-aliases.sh"
source_if_exists "$dots/wal-fill.sh"
source_if_exists "$dots/git-clone-bare.sh"
alias knitr="$dots/knitr.sh"
alias hm-switch="$shell $dots/hm-switch.sh"
alias hm-update="$shell $dots/hm-update.sh"
alias nixos-switch="bash ${dots}/nixos-rebuild.sh"
alias tplnew="create_file_template"
alias tpladd="add_template"
source_if_exists "$dots/wg.sh"

# git
alias ga="git add"
alias gd="git diff -U0"
alias gs="git status"
alias ci="git commit -S -m"
alias gp="git push"
alias gcl="git-clone-bare"
alias gb="git branch"
alias gch="git checkout"
alias gw="git worktree"

# python
alias p="python"

# latex
alias ltc="latexmk -pdf"
alias ltclean="latexmk -c"

# pdf viewing
pdfz() {
    if [ $# -eq 0 ]; then
        echo "Error: No arguments provided. Please specify a file to open with zathura."
        return 1
    fi
    zathura "$@" & disown
}

# docker
alias dps="docker ps"
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
dex() { docker exec -it "$1" "${2:-bash}"; }

# kubernetes
kns() {
    pushd "${HOME}/workspace/" || return
    k9s --logoless "$@"
    popd || return
}
alias kpf="kubectl port-forward"

# nix
alias ncg="nix-collect-garbage"

# directories
alias dn="cd ~/Downloads"
# alias notes='cd $(fd . ~/notes --type d | fzf)'
alias notes='cd ~/notes'

# tmux
# source "${dots}/tmux-sessionizer.sh"
tmux-sessionizer() {
    "${dots}/tmux-sessionizer.sh" "$@"
}
alias ts="tmux-sessionizer"
alias ta="tmux attach"
alias tl="tmux ls"

# waybar
alias waybar-restart="pkill waybar && waybar & disown %"
# alias waybar-restart="pkill waybar && hyprctl dispatch exec waybar"

# Wallpaper setter
feh-fill() {
    feh --bg-fill "$@"
}

# keymaps
if [ "$shell" = "bash" ]; then
    bind -x '"\C-f":tmux-sessionizer'
    bind -x '"\C-g":sd \n'
elif [ "$shell" = "zsh" ] || [ "$shell" = "-zsh" ]; then
    bindkey -s ^F 'tmux-sessionizer\n'
    bindkey -s ^G 'sd\n'
fi

