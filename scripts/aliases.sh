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

# vim
alias vim="nvim"
alias v="vim"
alias vi="vim"

# Alias fdfind (ubuntu package) to fd
if command -v fdfind >/dev/null 2>&1; then
    alias fd="fdfind"
fi

# better cd
alias sd='cd ./$(fd -L . --type d | fzf)'
alias sdh='cd $(fd -L . ~/ --type d | fzf)'
# alias s='cd $(fd . ~/ --type d | fzf)'
alias vd='vim $(fd . --type f | fzf)'
alias vdh='vim $(fd . ~/ --type f | fzf)'
alias vh='vim $(fd . ~/ --type f | fzf)'

# scripts
source_if_exists "$dots/ssh.sh"
source_if_exists "$dots/server-aliases.sh"
source_if_exists "$dots/wal-fill.sh"
source_if_exists "$dots/time-tracking.sh"
source_if_exists "$dots/create-from-template.sh"
alias knitr="$dots/knitr.sh"
alias note="$dots/make-note.sh"
alias hm-switch="$shell $dots/hm-switch.sh"
alias hm-update="$shell $dots/hm-update.sh"
alias tplnew="create_file_template"
alias tpladd="add_template"

# python
alias p="python"

# latex
alias ltc="latexmk -pdf"
alias ltcl="latexmk -pvc --silent"
alias ltclean="latexmk -c"

# git
alias ga="git add"
alias gd="git diff -U0"
alias gs="git status"
alias ci="git commit -m"
alias gp="git push"
alias gcl="git clone"
gsw() {
    git switch "$@"
}
gb() {
    git branch "$@"
}
gch() {
    git checkout "$@"
}

# pdf viewing
pdfe() {
    if [ $# -eq 0 ]; then
        echo "Error: No arguments provided. Please specify a file to open with evince."
        return 1
    fi
    evince "$@" & disown
}

pdfz() {
    if [ $# -eq 0 ]; then
        echo "Error: No arguments provided. Please specify a file to open with zathura."
        return 1
    fi
    zathura "$@" & disown
}

# TODO: pandoc conversions
# pandoc -o output.docx -f markdown -t docx input.md

# docker
alias dps="docker ps"
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"

dex() {
    docker exec -it "$1" "${2:-bash}"
}

# nix
alias nd="nix develop"
alias ncg="nix-collect-garbage"

# direnv
alias da="direnv allow"
alias dda="direnv disallow"
alias ndr="nix-direnv-reload"

# Directories
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias proj="cd ~/projects"
alias sch="cd ~/school"
# alias notes="cd ~/Documents/notes"
alias notes='cd $(fd . ~/notes --type d | fzf)'

tmux-sessionizer() {
    "$HOME/dotfiles/scripts/tmux-sessionizer.sh"
}

# map tmux sessionizer to ctrl+f
if [ "$shell" = "bash" ]; then
    bind -x '"\C-f":tmux-sessionizer'
elif [ "$shell" = "zsh" ]; then
    bindkey -s ^f 'tmux-sessionizer\n'
fi
