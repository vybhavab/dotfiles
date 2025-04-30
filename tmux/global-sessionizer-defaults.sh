#!/usr/bin/env bash

if [[ "$(pwd)" == $HOME/personal || "$(pwd)" == $HOME/projects || "$(pwd)" == $HOME/.dotfiles ]]; then
    clear
    return
fi

tmux new-window -dn scratch
nvim .
clear
