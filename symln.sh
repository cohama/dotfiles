#!/bin/sh
for i in .?*; do
  if [ $i != '..' ] && [ $i != '.git' ]; then
    ln -Fsi ~/dotfiles/$i ~
  fi
done

