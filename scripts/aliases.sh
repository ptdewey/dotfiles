#!/bin/bash

dots="$HOME/dotfiles/scripts"

source_if_exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}


# general
alias c="clear"
# alias ls="lsd"
alias ls="ls"
alias ll="ls -lF"
alias la="ls -a"
alias l="ls -F"

# vim
alias vim="nvim"
alias v="vim"
alias vi="vim"

# better cd
alias sd='cd ./$(fd . --type d | fzf)'
alias sdh='cd $(fd . ~/ --type d | fzf)'
alias vd='vim $(fd . ~/ --type f | fzf)'
alias vdh='vim $(fd . ~/ | fzf)'

# scripts
alias knitr="source $dots/knitr.sh"
alias knitr-html="source $dots/knitr-html.sh"
source_if_exists "$dots/ssh.sh"
source_if_exists "$dots/server-aliases.sh"
source_if_exists "$dots/wal-fill.sh"
source_if_exists "$dots/time-tracking.sh"

# python
alias p="python"
alias coa="conda activate"
alias cod="conda deactivate"

# latex
alias ltc="latexmk -pvc --silent"
alias ltclean="latexmk -c"

# Git
alias gs="git status"
alias gd="git diff"

# Docker
function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
    do
        docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dim="docker images"
alias dps="docker ps"
alias dex=dex-fn
alias di=di-fn
alias dnames=dnames-fn
alias drmid=drmid-fn

# Kubernetes 
# alias k="kubectl"
# alias kg="kubectl get"
# alias kgpo="kubectl get pods"
# alias kgsvc="kubectl get svc"
# alias kgcm="kubectl get configmaps"
# alias ka="kubectl apply"
# alias kaf="kubectl apply -f"
# alias krm="kubectl delete"
# alias krmf="kubectl delete -f"
# alias kpf="kubectl port-forward"

# Directories
alias conf="cd ~/.config"
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias proj="cd ~/Documents/projects"
alias sch="cd ~/Documents/school"
alias notes="cd ~/Documents/notes"
