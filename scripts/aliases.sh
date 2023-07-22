#!/bin/bash

# general
alias c="clear"
alias ll="ls -lF"
alias la="ls -aF"
alias l="ls -F"

# vim
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# scripts
alias cinit="source ~/dotfiles/scripts/conda-starter.sh"
alias jn="source ~/dotfiles/scripts/jupyter-starter.sh"
alias jl="source ~/dotfiles/scripts/jupyter-lab-starter.sh"
alias knitr="source ~/dotfiles/scripts/knitr.sh"
alias knitr_html="source ~/dotfiles/scripts/knitr_html.sh"
source ~/dotfiles/scripts/ssh.sh
source ~/dotfiles/scripts/wal-fill.sh

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
alias k="kubectl"
alias kg="kubectl get"
alias kgpo="kubectl get pods"
alias kgsvc="kubectl get svc"
alias kgcm="kubectl get configmaps"
alias ka="kubectl apply"
alias kaf="kubectl apply -f"
alias krm="kubectl delete"
alias krmf="kubectl delete -f"
alias kpf="kubectl port-forward"

# Directories
alias conf="cd ~/.config"
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias proj="cd ~/Documents/projects"
alias sch="cd ~/Documents/school"
alias c34="cd ~/Documents/school/cmda3634/"
alias s23="cd ~/Documents/school/cmda3634/s2023"
alias c34m="cd ~/Documents/school/cmda3634/s2023/cmda3634_materials"
alias c54="cd ~/Documents/school/cmda4654"
alias c06="cd ~/Documents/school/cmda3606"
alias s44="cd ~/Documents/school/stat4444"
alias m34="cd ~/Documents/school/math2534"

