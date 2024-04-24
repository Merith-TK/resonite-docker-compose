#!/bin/bash
## Set default env
if [ ! -n "$COMMAND" ]; then
    COMMAND="/scripts/99_start.sh"
fi
if [ ! -n "$CONFIG_FILE" ]; then
    CONFIG_FILE="/data/config.json"
fi

mkdir -p /data/home /data/headless /data/steamcmd /etc/crystite/conf.d
##  Have to do this here, as otherwise stuff doesnt work for some reason
/scripts/01_install.sh
/scripts/02_setup_config.sh
/scripts/03_download_mods.sh
if [ "$RUN_AS" != "" ]; then
    echo "Running as $RUN_AS"
    USER_ID=$(echo $RUN_AS | cut -d: -f1)
    GROUP_ID=$(echo $RUN_AS | cut -d: -f2)
    echo "User ID: $USER_ID"
    echo "Group ID: $GROUP_ID"

    groupadd -g $GROUP_ID user
    useradd -l -u $USER_ID -g $GROUP_ID user -d /data/home
    cd /data/home
    chown $USER_ID:$GROUP_ID /data -R
    chown $USER_ID:$GROUP_ID /etc/crystite -R

    echo "executing command: $COMMAND"
    exec sudo -E -u user $COMMAND

else
    # If RUN_AS is not defined, execute the command as root
    exec $COMMAND
fi
