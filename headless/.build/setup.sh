#!/bin/bash

if [ ! -n "$COMMAND" ]; then
    COMMAND="/start_script.sh"
fi

mkdir -p /data/home /data/headless /data/steamcmd

if [ -n "$RUN_AS" ]; then
    echo "Running as $RUN_AS"
    USER_ID=$(echo $RUN_AS | cut -d: -f1)
    GROUP_ID=$(echo $RUN_AS | cut -d: -f2)

    groupadd -g $GROUP_ID user
    useradd -l -u $USER_ID -g $GROUP_ID user

    chown user:user /data -R

    echo "executing command: $COMMAND"
    exec sudo -E -u user $COMMAND
else
    # If RUN_AS is not defined, execute the command as root
    exec $COMMAND
fi
