#!/usr/bin/env bash
# This is a file meant to be shared between my bashrc and zshrc configurations
# it aggregates path extensions and imports aliases

# add ./ to path
export PATH="$PATH:./"

# deal with conda (and zsh) clear issue
if [ -d "$HOME/anaconda3" ]; then
    export PATH="/home/patrick/anaconda3/bin:/home/patrick/anaconda3/condabin:$PATH"
fi

# add julia to path
if [ -d "$HOME/.local/bin/julia-1.7.3/bin" ]; then
    export PATH="$PATH:/home/patrick/.local/bin/julia-1.7.3/bin"
fi

# add .local/bin to path
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# add go to path
if [ -d "/usr/local/go/bin" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

# Fetch aliases
if [ -f "$HOME/dotfiles/scripts/aliases.sh" ]; then
    source "$HOME/dotfiles/scripts/aliases.sh"
fi
