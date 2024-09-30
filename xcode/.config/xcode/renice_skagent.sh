#!/bin/bash

# this process is used by xcode for code completions
# it regularly has memory leaks and freezes the system. this lowers the cpu priority of it.
while true; do
    pid=$(pgrep com.apple.dt.SKAgent)

    if [[ ! -z "$pid" ]]; then
        renice 20 $pid
    fi

    sleep 60
done

