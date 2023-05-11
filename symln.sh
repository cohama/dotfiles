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

# alacritty
mkdir -p ~/.config/alacritty
ln -Fsi ~/dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml

# twmn
mkdir -p ~/.config/twmn
ln -Fsi ~/dotfiles/twmn.conf ~/.config/twmn

# sxiv
mkdir -p ~/.config/sxiv/exec
ln -Fsi ~/dotfiles/sxiv-key-hander ~/.config/sxiv/exec/key-handler

# fonts
mkdir -p ~/.config/fontconfig
ln -Fsi ~/dotfiles/fonts.conf ~/.config/fontconfig/fonts.conf

# polybar
ln -Fsi ~/dotfiles/polybar ~/.config/

# picom
ln -Fsi ~/dotfiles/picom.conf ~/.config
