#!/bin/sh
for i in .?*; do
  echo $i
  if [ $i != '..' ] && [ $i != '.git' ]; then
    ln -Fsi ~/dotfiles/$i ~
  fi
done

# xmonad
mkdir -p ~/.xmonad
ln -Fsi ~/dotfiles/xmonad.hs ~/.xmonad

