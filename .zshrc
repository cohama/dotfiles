autoload -Uz compinit && compinit
autoload -U colors && colors

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
alias T='tmux -2'

source ~/dotfiles/git-prompt.sh

# colored completion
eval `dircolors -b`

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'                 menu select=2

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

## correction
# some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
if [[ "$NOCOR" -gt 0 ]] ; then
    zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
    setopt nocorrect
else
    # try to be smart about when to use what completer...
    setopt correct
    zstyle -e ':completion:*' completer '
        if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
            _last_try="$HISTNO$BUFFER$CURSOR"
            reply=(_complete _match _ignored _prefix _files)
        else
            if [[ $words[1] == (rm|mv) ]] ; then
                reply=(_complete _files)
            else
                reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
            fi
        fi'
fi

# command for process lists, the local web server details and host completion
zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
                        zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# host completion
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  $(hostname)
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts
# TODO: so, why is this here?
#  zstyle '*' hosts $hosts

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
               pal stow tail uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# see upgrade function in this file
compdef _hosts upgrade

# environment variables
export LANG=ja_JP.UTF-8

# prompt
precmd() {
  local preexit=$?
  psvar=()
  psvar[1]=$(__git_ps1 "(git: %s)")
  if [[ preexit -eq 0 ]]; then
    psvar[2]=""
  else
    psvar[2]="[$preexit]"
  fi
}
PROMPT="%B%{$fg[cyan]%}%n@%m: %{$fg[red]%}%~%{$fg[yellow]%} %1v%f%{$reset_color%}
%# "
RPROMPT="%{$fg_no_bold[green]%}%2v%{$reset_color%}"

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
      echo -e "$fg_no_bold[yellow]--- git status ---$reset_color"
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
source ~/.opam/opam-init/init.zsh > /dev/null 2>&1 || true

# rbenv
command -v rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"

# golang
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# peco
[[ -e ~/dotfiles/peco.zsh ]] && source ~/dotfiles/peco.zsh

# tmuxinator.zsh
source ~/dotfiles/tmuxinator/tmuxinator.zsh

# Haxe
export HAXE_STD_PATH=/opt/haxe/std

# My local settings
source ~/dotfiles/.local.zsh
