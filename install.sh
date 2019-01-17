#!/bin/bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# vim
ln -s ${BASEDIR}/vimrc ~/.vimrc

# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc

# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

#hyper
ln -s ${BASEDIR}/hyper.js ~/.hyper.js

#i3
ln -s ${BASEDIR}/config/i3/config ~/.config/i3/config

#polybar
ln -s ${BASEDIR}/config/polybar/config ~/.config/polybar/config
