#!/bin/bash
## Set default env
if [ ! -n "$COMMAND" ]; then
    COMMAND="/scripts/99_start.sh"
fi
if [ ! -n "$CONFIG_FILE" ]; then
    CONFIG_FILE="/data/Config.json"
fi

if [ ! -n "$RESONITE_ARGS" ]; then
    RESONITE_ARGS=""
fi

export DEFAULT_RESONITE_ARGS="-LogsPath /data/resonite/logs \
    -DataPath /data/app/data \
    -CachePath /data/app/cache \
    -HeadlessConfig $CONFIG_FILE \
    $RESONITE_ARGS"

mkdir -p /data/home /data/resonite /data/steamcmd /etc/crystite/conf.d
##  Have to do this here, as otherwise stuff doesnt work for some reason
# using source so runtime vars can be updated as needed
source /scripts/01_install.sh
source /scripts/02_setup_config.sh
source /scripts/03_download_mods.sh
if [ "$RUN_AS" != "" ]; then
    echo "Running as $RUN_AS"
    USER_ID=$(echo $RUN_AS | cut -d: -f1)
    GROUP_ID=$(echo $RUN_AS | cut -d: -f2)
    echo "User ID: $USER_ID"
    echo "Group ID: $GROUP_ID"

    groupadd -g $GROUP_ID user
    useradd -l -u $USER_ID -g $GROUP_ID user -d /home/user

    export HOME="/home/user"
    chown $USER_ID:$GROUP_ID /data -R
    chown $USER_ID:$GROUP_ID /etc/crystite -R

    echo "executing command: $COMMAND"
    exec sudo -E -u user $COMMAND

else
    # If RUN_AS is not defined, execute the command as root
    echo "executing command: $COMMAND"
    exec $COMMAND
fi
