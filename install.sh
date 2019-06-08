#!/bin/bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# vim
ln -s ${BASEDIR}/vimrc ~/.vimrc

#nvim 
ln -s ${BASEDIR}/config/nvim ~/.config/

ln -s ${BASEDIR}/config/betterlockscreenrc ~/.config/betterlockscreenrc

# zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc

#tmux
ln -s ${BASEDIR}/tmux.conf ~/.tmux.conf

#autorandr
ln -s ${BASEDIR}/config/autorandr/docked/postswitch ~/.config/autorandr/docked/

ln -s ${BASEDIR}/config/autorandr/mobile/postswitch ~/.config/autorandr/mobile/

#termite
ln -s ${BASEDIR}/config/termite/config ~/.config/termite/config

# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

#hyper
ln -s ${BASEDIR}/hyper.js ~/.hyper.js

#i3
ln -s ${BASEDIR}/config/i3 ~/.config/

#ranger
ln -s ${BASEDIR}/config/ranger ~/.config/

#polybar
ln -s ${BASEDIR}/config/polybar ~/.config/

#rofi
ln -s ${BASEDIR}/config/rofi ~/.config/

#compton
ln -s ${BASEDIR}/config/compton ~/.config/

#dunst
#ln -s ${BASEDIR}/config/dunst/dunstrc ~/.config/dunst/dunstrc
ln -s ${BASEDIR}/config/dunst ~/.config

#conky
ln -s ${BASEDIR}/config/conky ~/.config

#chrome
ln -sv ${BASEDIR}/config/chrome-flags.conf ~/.config/chrome-flags.conf

#devilspie
ln -s ${BASEDIR}/devilspie/vscode_transparent.ds ~/.devilspie/vscode_transparent.ds

#fusuma
ln -s ${BASEDIR}/config/fusuma ~/.config/fusuma
