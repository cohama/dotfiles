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
alias c_='cd $_'

# enable git completion
zstyle ':completion:*:*:git:*' script ~/dotfiles/git-completion.bash
fpath=(~/.zsh $fpath)
# source ~/dotfiles/git-completion.zsh
# source ~/dotfiles/git-completion.bash
source ~/dotfiles/git-prompt.sh

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
setopt extendedglob

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

function man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

export EDITOR='vim'
export PAGER='less'
export LESS='-XFMWR'

# cabal
export CABAL_HOME=~/.cabal
export PATH=$CABAL_HOME/bin:$PATH

# nodebrew
export NODEBREW_HOME=$HOME/.nodebrew/current
export PATH=$NODEBREW_HOME/bin:$PATH

export PATH=~/.vim/bundle/vim-themis/bin:$PATH

# OPAM configuration
. /home/cohama/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# rbenv
if [[ -d ~/.rbenv ]]; then
  export RBENV_HOME=~/.rbenv
  export PATH=$RBENV_HOME/bin:$PATH
  eval "$(rbenv init -)"
fi

# golang
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# peco
[[ -e ~/dotfiles/peco.zsh ]] && source ~/dotfiles/peco.zsh

# tmuxinator.zsh
source ~/dotfiles/tmuxinator/tmuxinator.zsh

# Haxe
export HAXE_STD_PATH=/opt/haxe/std

# Vim
export PATH=~/app/vim/bin:$PATH

# My local settings
source ~/dotfiles/.local.zsh
