#!/bin/bash

local dots="$HOME/dotfiles/scripts"


# general
alias c="clear"
alias ls="lsd"
alias ll="ls -lF"
alias la="ls -a"
alias l="ls -F"

# better cd
alias sd='cd ./$(fd . --type d | fzf)'
alias sdh='cd $(fd . ~/ --type d | fzf)'
alias vd='vim $(fd . ~/ --type f | fzf)'
alias vdh='vim $(fd . ~/ | fzf)'

# vim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# scripts
alias cinit="source $dots/conda-starter.sh"
alias knitr="source $dots/knitr.sh"
alias knitr_html="source $dots/knitr_html.sh"
source "$dots/ssh.sh"
source "$dots/wal-fill.sh"
source "$dots/time-tracking.sh"

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
# alias c34="cd ~/Documents/school/cmda3634/"
alias c34='cd $(fd . ~/Documents/school/cmda3634 --type d | fzf)'
# alias s34="cd ~/Documents/school/stat4534"
alias s34='cd $(fd . ~/Documents/school/stat4534 --type d | fzf)'
# alias c14="cd ~/Documents/school/cs3114"
alias c14='cd $(fd . ~/Documents/school/cs3114 --type d | fzf)'
alias cap="cd ~/Documents/school/capstone"
alias cu="cd ~/Documents/school/cmda4634"
alias notes="cd ~/Documents/notes"
