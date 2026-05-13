#!/usr/bin/env bash
# This is a file meant to be shared between my bashrc and zshrc configurations
# it aggregates path extensions and imports aliases

# set custom color scheme (if not in tty)
if [ -f "$HOME/dotfiles/scripts/base16-darkearth.sh" ] && [ -n "$DISPLAY" ]; then
    source "$HOME/dotfiles/scripts/base16-darkearth.sh"
fi

export VISUAL=nvim
export FZF_DEFAULT_COMMAND='rg --files'
# export FZF_DEFAULT_OPTS='-m --border --height 60% --preview "cat {}"'
export FZF_DEFAULT_OPTS='-m --border'

export PATH="$PATH:$HOME/.local/bin:$HOME/dotfiles/scripts/bin:./"

# Add cargo install dir to path
if [ -d "$HOME/.cargo" ]; then
    export PATH=$PATH:"$HOME/.cargo/bin"
    # source "$HOME/.cargo/env"
fi

# add go install dir to path
if [ -d "/usr/local/go/bin" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

# add packages installed with go
if [ -d "$HOME/go/bin" ]; then
    export PATH="$PATH:${HOME}/go/bin"
fi

# nix home-manager session variables
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# add nix binaries to path
if [ -e "$HOME/.nix-profile/bin" ]; then
    export PATH=$PATH:"$HOME/.nix-profile/bin"
    export NIX_BUILD_CORES=8
fi

# nix daemon
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if [ -e "$HOME/.nix-profile/share" ]; then
    export XDG_DATA_DIRS="/home/your_user/.nix-profile/share:$XDG_DATA_DIRS"
fi


if command -v "direnv" &> /dev/null; then
    eval "$(direnv hook `ps -p \$\$ -o 'comm='`)"
fi

# Fetch aliases
if [ -f "$HOME/dotfiles/scripts/aliases.sh" ]; then
    source "$HOME/dotfiles/scripts/aliases.sh"
fi

source "$HOME/dotfiles/scripts/s3-copy.sh"

# machine specific aliases
if [ -f "$HOME/.aliases.sh" ]; then
    source "$HOME/.aliases.sh"
fi

export PATH=$HOME/.npm-global/bin:$PATH
