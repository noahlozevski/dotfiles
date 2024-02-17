#!/bin/zsh

if [[ $# -eq 1 ]]; then
    selected=$1
else
    running_sessions=$(tmux list-sessions -F "#{session_name}" 2> /dev/null)
    workplaces=$(find /Users/noahlozevski/code -mindepth 1 -maxdepth 1 -type d ! -name '.*')
    # start a fuzzy find search on all workspace folders
    selected=$({ echo $workplaces && echo $running_sessions } | sort | uniq | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $selected_name
else 
    tmux switch-client -t $selected_name
fi
tmux switch-client -t $selected_name
