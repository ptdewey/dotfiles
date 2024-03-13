#!/usr/bin/env bash

dots="$HOME/dotfiles/scripts"

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
# if [ -f "/usr/bin/fdfind" ]; then
if command -v fdfind >/dev/null 2>&1; then
    alias fd="fdfind"
fi
# better cd
alias sd='cd ./$(fd . --type d | fzf)'
alias sdh='cd $(fd . ~/ --type d | fzf)'
alias vd='vim $(fd . --type f | fzf)'
alias vdh='vim $(fd . ~/ --type f | fzf)'

# scripts
source_if_exists "$dots/ssh.sh"
source_if_exists "$dots/server-aliases.sh"
source_if_exists "$dots/wal-fill.sh"
source_if_exists "$dots/time-tracking.sh"
source_if_exists "$dots/create-from-template.sh"
alias knitr="source $dots/knitr.sh"
alias note="$dots/make-note.sh"
alias tplnew="create_file_template"
alias tpladd="add_template"

# python
alias p="python"

# latex
alias ltc="latexmk -pvc --silent"
alias ltclean="latexmk -c"

# git
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias ci="git commit -m"

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

# Docker
dex() { docker exec -it $1 ${2:-bash}; }
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"

# Directories
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias proj="cd ~/Documents/projects"
alias sch="cd ~/Documents/school"
alias notes="cd ~/Documents/notes"

