autoload -Uz compinit && compinit

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
alias gitinit='git init && git commit --allow-empty -minit'
alias be='bundle exec'
alias -g LL='| less'
alias vi='vim -u NONE -N'
alias ,='cd ..'
alias ,,='popd'

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
bindkey -M viins "" beginning-of-line
bindkey -M viins "" end-of-line
bindkey -M viins "" forward-char
bindkey -M viins "" backward-char
bindkey -M viins "" kill-line
setopt auto_pushd
setopt correct
unsetopt extended_glob

function do_enter() {
  if [ -z "$BUFFER" ]; then
    echo
    ls -F
  elif [ "$BUFFER" = " " ]; then
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
      echo
      echo -e "\e[0;33m--- git status ---\e[0m"
      git status -s
    fi
  fi
  zle accept-line
  return 0
}
zle -N do_enter
bindkey '^m' do_enter

function do_space() {
  if [ "$BUFFER" = " " ]; then
    LBUFFER="git "
  else
    LBUFFER="$LBUFFER "
  fi
}
zle -N do_space
bindkey ' ' do_space

function mkcd() {
  if [[ -d $1 ]]; then
    echo "already exists"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}

export EDITOR='vim'
