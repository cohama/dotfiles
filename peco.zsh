function peco-pushd() {
  eval cd $(pushd | sed -e "s/ /\n/g" | peco)
  zle reset-prompt
}
zle -N peco-pushd

function peco-command-history() {
  BUFFER=$(history -n 1 | tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N peco-command-history

function peco-git-log() {
  GIT_COMMIT_HASH=$(git log --oneline --graph --all --decorate | peco | sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
  if [[ -z $BUFFER ]]; then
    BUFFER="git  $GIT_COMMIT_HASH"
    CURSOR=4
  else
    BUFFER=${BUFFER}${GIT_COMMIT_HASH}
    CURSOR=$#BUFFER
  fi
}
zle -N peco-git-log

bindkey "d" peco-pushd
bindkey "m" peco-command-history
bindkey "k" peco-git-log
