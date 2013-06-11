# If not running interactively, don't do anything
[ -z "$PS1" ] && return

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# some more ls aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias lla='ls -alF'
alias ll='ls -lF'
alias la='ls -AF'
alias l='ls -CF'
alias chrome='/opt/google/chrome/chrome'
alias gvim='gvim -f'
alias cdv='cd ~/.vim'
alias cdp='cd ~/proj'
alias cdt='cd ~/tmp'
alias :q=exit

# enable git completion
source ~/dotfiles/git-completion.bash

# environment variables
export LANG=ja_JP.UTF-8

# prompt
precmd() {
  psvar=()
  psvar[1]=$(__git_ps1 "(git: %s)")
}
PROMPT="%B%F{cyan}%n@%m: %F{red}%~%F{yellow} %1v%f%b
%# "

# configuration
setopt auto_cd
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
bindkey -v
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end
setopt auto_pushd
unsetopt correct
unsetopt extended_glob

export EDITOR='vim'

