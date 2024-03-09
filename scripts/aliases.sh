#!/bin/bash

dots="$HOME/dotfiles/scripts"

source_if_exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

# general
alias c="clear"
if [[ -f "$HOME/.cargo/bin/lsd" ]]; then
    alias ls="lsd"
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

# better cd
if [[ -f "/usr/bin/fdfind" ]]; then
    alias fd="fdfind"
fi
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

# Docker
function dex-fn {
	docker exec -it $1 ${2:-bash}
}
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dex=dex-fn

# Directories
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias proj="cd ~/Documents/projects"
alias sch="cd ~/Documents/school"
alias notes="cd ~/Documents/notes"
