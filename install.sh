#!/bin/bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# vim
ln -s ${BASEDIR}/vimrc ~/.vimrc

ln -s ${BASEDIR}/config/betterlockscreenrc ~/.config/betterlockscreenrc

# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc

#tmux
ln -s ${BASEDIR}/tmux.conf ~/.tmux.conf

ln -s ${BASEDIR}/config/autorandr ~/.config/autorandr

#termite
ln -s ${BASEDIR}/config/termite/config ~/.config/termite/config

# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

#hyper
ln -s ${BASEDIR}/hyper.js ~/.hyper.js

#i3
ln -s ${BASEDIR}/config/i3 ~/.config/

#polybar
ln -s ${BASEDIR}/config/polybar ~/.config/

#rofi
ln -s ${BASEDIR}/config/rofi ~/.config/

#dunst
#ln -s ${BASEDIR}/config/dunst/dunstrc ~/.config/dunst/dunstrc
ln -s ${BASEDIR}/config/dunst ~/.config

#chrome
ln -sv ${BASEDIR}/config/chrome-flags.conf ~/.config/chrome-flags.conf
