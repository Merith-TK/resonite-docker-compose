#!/bin/bash

## Setup Resonite Config
echo  "Setting up Resonite Config"

DEFAULT_RESONITE_ARGS="-LogsPath /data/resonite/logs -DataPath /data/resonite/data -CachePath /data/resonite/cache"
DEFAULT_RESONITE_ARGS="$DEFAULT_RESONITE_ARGS -HeadlessConfig $CONFIG_FILE"

# if CONFIG_FILE is not set, use default config path
if  [ ! -f $CONFIG_FILE ]; then
    echo "No Resonite Config found, copying from template"
    cat /mnt/crystite/resonite.json | jq '.' >  $CONFIG_FILE
fi
echo "Generating Crystite configs"
if [ ! -f "/etc/crystite/appsettings.json" ]; then
    cat /mnt/crystite/appsettings.json | jq '.' > /etc/crystite/appsettings.json
fi
CONFIG_DATA=$(grep -v " null," "$CONFIG_FILE")
JQ_STRING=".comment = \"DO NOT EDIT: This file was automatically generated. Please edit $CONFIG_FILE instead.\""
CONFIG_DATA=$(echo "$CONFIG_DATA" | jq "$JQ_STRING")


echo "{ \"Resonite\": $CONFIG_DATA }" | jq '.' > /etc/crystite/conf.d/_generated_resonite.json

## Setup Modloader Configs
if [ "$RESONITE_MOD_LOADER" == "true" ]; then
    echo  "Setting up Modloader Configs" 
    echo "{\"Resonite\": {\"pluginAssemblies\": [\"/data/headless/Headless/Libraries/ResoniteModLoader.dll\"]}}" | jq '.' > /etc/crystite/conf.d/_generated_rml.json
    DEFAULT_RESONITE_ARGS="$DEFAULT_RESONITE_ARGS -LoadAssembly Libraries/ResoniteModLoader.dll"
else
    echo  "Modloader is disabled"
    rm -f /etc/crystite/conf.d/_generated_rml.json
fi
