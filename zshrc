# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)
# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

if [ -d ~/.repos/powerlevel10k ]; then
    source ~/.repos/powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# Load zsh plugins
if [ -d ~/.repos/zsh-autosuggestions ]; then
    source ~/.repos/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ~/.repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # source ~/.repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e

# Change the look of the prompt
PS1="%n %~ %"

# Set vim to default editor
export EDITOR=nvim

# Keybinds (for ergo keyboard)
bindkey -s "^[Om" "-"
bindkey -s "^[Ok" "+"

# Unbind autocomplete behavior from l/r arrow keys
bindkey '\e[D' backward-char
bindkey '\eOD' backward-char
bindkey '\e[C' forward-char
bindkey '\eOC' forward-char

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

export TERMINFO=/usr/share/terminfo

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
