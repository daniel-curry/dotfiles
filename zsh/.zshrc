source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

source ~/.zsh_plugins.zsh

PROMPT='%B%F{cyan}%n%f %F{blue}%~%b%f $ '

# Source sensitive variables (if ~/.zsh_secrets exists)
[[ -f "$HOME/.zsh_secrets" ]] && source "$HOME/.zsh_secrets"


# Aliases
alias update='sudo pacman -Syu && yay -Syu'

alias fuck='sudo $(fc -ln -1)'

alias q='exit'



alias airplay='uxplay -p 35000 -fps 60'


## cd into Syncthing Clone Project
alias synk='cd ~/Code/synk'

## Git Aliases (add more as needed)
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias ga='git add'

# Persistent Command History
HISTFILE=~/.zsh_history

HISTSIZE=10000

SAVEHIST=10000

setopt APPEND_HISTORY          # Don't overwrite history file, append to it
setopt INC_APPEND_HISTORY      # Write to history file immediately, not when shell exits
setopt SHARE_HISTORY           # Share history across all sessions
setopt HIST_IGNORE_DUPS        # Ignore duplicate commands
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicates, keep latest


# Interactive binary choice for CMake nvim auto-run keymap
# (sets the .sh file to path so that it can be used anywhere)

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
