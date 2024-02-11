
cd /data/home
if [ -n $DISABLE_STEAMCMD ]; then
    echo "Running SteamCMD"
    if [ ! -f "/data/steamcmd/steamcmd.sh" ]; then
        cd /data/steamcmd
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    fi
    /data/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /data/headless +app_update 2519830 -beta headless -betapassword ${STEAM_BETA} +quit
fi

if [ ! -n $USE_CRYSTITE ]; then
    echo "Running Crystite"
    /usr/lib/crystite/crystite
else 
    cd /data/headless/Headless
    if [ -n $RESONITE_MOD_LOADER ]; then
        echo "Running Resonite"
        mono Resonite.exe
    else
        echo "Running Resonite Mod Script"
        /mods_script.sh
        echo "Running Resonite with Mod Loader"
        mono Resonite.exe -LoadAssembly Libraries/ResoniteModLoader.dll
    fi
fi