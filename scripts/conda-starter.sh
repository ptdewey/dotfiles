#!/bin/bash

# provide quicker terminal startup times by only starting anaconda when needed

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/patrick/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/patrick/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/patrick/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/patrick/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# CONDA_AUTO_ACTIVATE_BASE=false
# <<< conda initialize <<<

# realias to avoid multiple sessions
alias cinit="echo anaconda is already running"
