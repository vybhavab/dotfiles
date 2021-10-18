# Thanks to @ThePrimeagen for this. https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    items=`find ~/work -maxdepth 1 -mindepth 1 -type d`
    items+=`find ~/personal -maxdepth 1 -mindepth 1 -type d`
    items+=("$HOME/personal")
    items+=("$HOME/work")
    items+=("$HOME/.dotfiles")
    selected=`echo "$items" | fzf`
fi

tmux_session_name=`basename $selected | tr . _`

tmux switch-client -t $tmux_session_name
if [[ $? -eq 0 ]]; then
    exit 0
fi

tmux new-session -c $selected -d -s $tmux_session_name && tmux switch-client -t $tmux_session_name || tmux new -c $selected -A -s $tmux_session_name