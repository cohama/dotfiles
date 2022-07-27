autoload -U path

# cabal
export CABAL_HOME=~/.cabal
export PATH=$CABAL_HOME/bin:$PATH

# themis
export PATH=~/.vim/bundle/vim-themis/bin:$PATH

# golang
export GOPATH=~/go
export PATH=~/go/bin:$PATH

# Haxe
export HAXE_STD_PATH=/opt/haxe/std

# local env
[[ -e ~/dotfiles/.local.zshenv ]] && source ~/dotfiles/.local.zshenv

# stack
export PATH=~/.local/bin:$PATH

# java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

# rust
export PATH=~/.cargo/bin:$PATH

# local executables
export PATH=~/local/bin:$PATH

# pyenv
export PATH=~/.pyenv/shims:$PATH

export BROWSER=firefox
