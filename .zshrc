# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz colors && colors

# cdr (used by anyframe)
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000

# colored completion
eval `dircolors -b`

# environment variables
export LANG=ja_JP.UTF-8

# antigen
if [[ -f /usr/share/zsh/scripts/zplug/init.zsh ]]; then
  source /usr/share/zsh/scripts/zplug/init.zsh

  zplug zdharma-continuum/fast-syntax-highlighting
  # zplug amaya382/zsh-fzf-widgets
  zplug mollifier/anyframe
  zplug romkatv/powerlevel10k, as:theme, depth:1
  zplug Aloxaf/fzf-tab

  if ! zplug check; then
    zplug install
  fi

  zplug load
fi

# oh-my-zsh defines unnecessary aliases
unalias -a

# fzf-tab

# configuration
setopt auto_cd
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
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey 'e'  edit-command-line
bindkey -M viins "" beginning-of-line
bindkey -M viins "" end-of-line
bindkey -M viins "" forward-char
bindkey -M viins "" backward-char
bindkey -M viins "" kill-line
setopt auto_pushd
setopt correct
setopt extendedglob

# some more ls aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias lla='ls -alFh'
alias ll='ls -lFh'
alias la='ls -AF'
alias l='ls -CF'
alias cdv='cd ~/.config/nvim'
alias cdp='cd ~/proj'
alias cdt='cd ~/tmp'
alias cdd='cd ~/Downloads'
alias :q=exit
alias gitinit='git init && git commit --allow-empty -minit'
alias -g LL='| less'
alias vi='vim -u ~/.config/nvim/.min.vimrc -N'
alias ,='cd ..'
alias ,,='popd'
alias c_='cd $_'
alias sudo='sudo '
alias sc='systemctl'
alias mv='mv -i'
alias -g XX='| xsel -b'
alias gcd='cd $(git rev-parse --show-toplevel)'
alias px='poetry run'
alias pox='poetry run'
alias v='nvim'
alias doco='docker compose'

function do_enter() {
  if [ -z "$BUFFER" ]; then
    echo
    ls -F --color=auto
  elif [ "$BUFFER" = "git " ]; then
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
      echo
      echo -e "$fg_no_bold[yellow]--- git status ---$reset_color"
      git status -s
    fi
    BUFFER=""
  fi
  echo -en "\033[0m"
  zle accept-line
  return 0
}
zle -N do_enter
bindkey '^m' do_enter

function do_space() {
  if [ "$BUFFER" = "" ]; then
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

# colored man page
function man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[4;48;5;11;38;5;237m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man "$@"
}

# copy pwd without end of newline
function cwd() {
  pwd | tr -d "\n"
}

# readlink -f without end of newline
function rlf() {
  readlink -f "$@" | tr -d "\n"
}

export EDITOR='nvim'
export PAGER='less'
export LESS='-XFMWR'

export KEYTIMEOUT=1

# anyframe
zstyle ":anyframe:selector:" use fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --extended --no-sort'
bindkey "d" anyframe-widget-cdr
bindkey "m" anyframe-widget-put-history

function my-anyframe-widget-insert-cdr() {
  anyframe-source-cdr \
  | anyframe-selector-auto \
  | anyframe-action-insert
}

zle -N my-anyframe-widget-insert-cdr
bindkey "f" my-anyframe-widget-insert-cdr

function my-anyframe-widget-insert-ls() {
  ls \
  | anyframe-selector-auto \
  | anyframe-action-insert
}

zle -N my-anyframe-widget-insert-ls
bindkey "l" my-anyframe-widget-insert-ls

# bullet-train
BULLETTRAIN_PROMPT_ORDER=(
  context
  status
  dir
  git
  virtualenv
)
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_VIRTUALENV_BG=green
BULLETTRAIN_VIRTUALENV_FG=white
BULLETTRAIN_CONTEXT_DEFAULT_USER=cohama
if [[ -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
  BULLETTRAIN_IS_SSH_CLIENT=true
fi
BULLETTRAIN_DIR_EXTENDED=2

# OPAM configuration
source ~/.opam/opam-init/init.zsh > /dev/null 2>&1 || true

# rbenv
command -v rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"

# My local settings
[[ -e ~/dotfiles/.local.zsh  ]] && source ~/dotfiles/.local.zsh

# pyenv
command -v pyenv > /dev/null 2>&1 && eval "$(pyenv init -)"

if [[ -e ~/.dir_colors ]]; then
  eval $(dircolors ~/.dir_colors)
fi

# Pipenv
export PIPENV_VENV_IN_PROJECT=true

# fzf
export FZF_DEFAULT_OPTS="--layout=reverse"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# added by travis gem
[ ! -s /home/cohama/.travis/travis.sh ] || source /home/cohama/.travis/travis.sh
