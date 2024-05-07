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

autoload -U compinit; compinit
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# zstyle ':completion:*' file-sort modification

export TERMINFO=/usr/share/terminfo

# Fetch path additions and aliases
# rc.sh is shared with bashrc
if [ -f "$HOME/dotfiles/scripts/rc.sh" ]; then
    source "$HOME/dotfiles/scripts/rc.sh"
fi
