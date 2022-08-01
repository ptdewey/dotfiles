# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/patrick/.zshrc'

# Change the look of the prompt
PS1="%n %~ %"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)
# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

autoload -Uz compinit
compinit
# End of lines added by compinstall
source ~/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/repos/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/repos/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set vim to default editor
export EDITOR=nvim

# deal with conda (and zsh) clear issue
export PATH="/home/patrick/anaconda3/bin:/home/patrick/anaconda3/condabin:$PATH:./"
# add julia to path 
export PATH="$PATH:/home/patrick/.local/bin/julia-1.7.3/bin"

export TERMINFO=/usr/share/terminfo

# Fetch aliases
source ~/dotfiles/scripts/aliases.sh

