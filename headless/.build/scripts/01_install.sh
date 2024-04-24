#!/bin/bash
cd /data/home || exit
if [ "$DISABLE_STEAMCMD" != "true" ]; then
    echo "Running SteamCMD"
    if [ ! -f "/data/steamcmd/steamcmd.sh" ]; then
        cd /data/steamcmd || exit
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    fi
    /data/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /data/headless +app_update 2519830 -beta headless -betapassword ${STEAM_BETA} +quit
fi

if  [ ! -f "/data/headless/Headless/Resonite.exe" ]; then
    echo "ERROR: Resonite.exe not found. Exiting..."
    exit 1
else
    echo "Resonite.exe found"
fi