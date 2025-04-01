#!/usr/bin/env bash

if [[ "$(pwd)" == $HOME/personal || "$(pwd)" == $HOME/projects ]]; then
    clear
    return
fi

tmux new-window -dn scratch
nvim .
clear
