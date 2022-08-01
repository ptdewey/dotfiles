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
source ~/dotfiles/scripts/ssh.sh
source ~/dotfiles/scripts/wal-fill.sh

# python
alias p="python"
alias coa="conda activate"
alias cod="conda deactivate"

# C
alias gccc="gcc -std=c11 -Wall"
alias gcccw="gcc -std=c11 -Wall -W"

# Docker
# TODO

# Kubernetes 
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgc="kubectl get configmaps"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"
alias kpf="kubectl port-forward"

# Directories
alias config="cd ~/.config"
alias dn="cd ~/Downloads"
alias doc="cd ~/Documents"
alias sch="cd ~/Documents/School"
