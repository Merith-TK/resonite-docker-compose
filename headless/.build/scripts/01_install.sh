#!/bin/bash
cd /data/home || exit
if [ "$DISABLE_STEAMCMD" != "true" ]; then
    echo "Running SteamCMD"
    if [ ! -f "/data/steamcmd/steamcmd.sh" ]; then
        cd /data/steamcmd || exit
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    fi
    # if steam beta is empty, or matchs "beta_access_key" we don't need to dwonload the beta
    if [ -z "$STEAM_BETA" ] || [ "$STEAM_BETA" == "beta_access_key" ]; then
        echo "Downloading Resonite"
        /data/steamcmd/steamcmd.sh +login anonymous +force_install_dir /data/resonite +app_update 2519830 +quit
        USE_CRYSTITE="true"
    else
        echo "Downloading Resonite Headless"
        /data/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /data/resonite +app_update 2519830 -beta headless -betapassword ${STEAM_BETA} +quit
    fi
fi

# if crystite is enabled, we don't need to check for resonite
if [ "$USE_CRYSTITE" != "true" ]; then
    if [ ! -f "/data/resonite/Headless/Resonite.exe" ]; then
        echo "Headless/Resonite.exe not found!"
        exit 1
    fi
fi