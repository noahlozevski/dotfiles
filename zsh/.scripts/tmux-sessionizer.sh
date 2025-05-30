#!/bin/zsh

# use the default code dir if not set already
DEFAULT_CODE_DIR="/Users/noahlozevski/code"

# Override if CODE_DIR is set and not empty
if [ -n "$CODE_DIR" ]; then
  DEFAULT_CODE_DIR="$CODE_DIR"
fi

if [[ $# -eq 1 ]]; then
    selected=$1
else
    running_sessions=$(tmux list-sessions -F "#{session_name}" 2> /dev/null | sort | uniq)
    workplaces=$(find $DEFAULT_CODE_DIR -mindepth 1 -maxdepth 1 -type d ! -name '.*' | sort | uniq)
    # start a fuzzy find search on all workspace folders
    selected=$({ echo $running_sessions && echo $workplaces && echo 'dotfiles' } | uniq | fzf --header="Select a session or workspace:")
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
