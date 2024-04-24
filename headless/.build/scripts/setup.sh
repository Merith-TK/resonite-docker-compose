#!/bin/bash

if [ ! -n "$COMMAND" ]; then
    COMMAND="/scripts/start_script.sh"
fi

mkdir -p /data/home /data/headless /data/steamcmd /etc/crystite
##  Have to do this here, as otherwise stuff doesnt work for some reason
if  [ ! -f "/etc/crystite/appsettings.json" ]; then
    echo "No appsettings.json found, copying from backup"
    cp /mnt/crystite/appsettings.json /etc/crystite/appsettings.json
else
    echo "appsettings.json found, skipping copy"
fi
if [ "$RUN_AS" != "" ]; then
    echo "Running as $RUN_AS"
    USER_ID=$(echo $RUN_AS | cut -d: -f1)
    GROUP_ID=$(echo $RUN_AS | cut -d: -f2)
    echo "User ID: $USER_ID"
    echo "Group ID: $GROUP_ID"

    groupadd -g $GROUP_ID user
    useradd -l -u $USER_ID -g $GROUP_ID user -d /data/home

    chown $USER_ID:$GROUP_ID /data -R
    chown $USER_ID:$GROUP_ID /etc/crystite -R

    echo "executing command: $COMMAND"
    exec sudo -E -u user $COMMAND

else
    # If RUN_AS is not defined, execute the command as root
    exec $COMMAND
fi
