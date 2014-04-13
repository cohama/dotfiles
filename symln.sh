#!/bin/sh
for i in .?*; do
  if [ $i != '..' ] && [ $i != '.git' ] && [ &i != 'xmonad.hs' ]; then
    ln -Fsi ~/dotfiles/$i ~
  fi
  if [ &i != 'xmonad.hs' ]; then
    mkdir -p ~/.xmonad
    ln -Fsi ~/dotfiles/$i ~/.xmonad
  fi
done

