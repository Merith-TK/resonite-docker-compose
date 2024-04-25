#!/bin/bash

## Setup Resonite Config
echo  "Setting up Resonite Config"

# if CONFIG_FILE is not set, use default config path
if  [ ! -f $CONFIG_FILE ]; then
    echo "No Resonite Config found, copying from template"
    cp /mnt/crystite/resonite.json $CONFIG_FILE
    # cat /mnt/crystite/resonite.json | jq '.' >  $CONFIG_FILE
fi
echo "Generating Crystite configs"
if [ ! -f "/etc/crystite/appsettings.json" ]; then
    cat /mnt/crystite/appsettings.json | jq '.' > /etc/crystite/appsettings.json
fi

CONFIG_DATA=$(grep -v " null," "$CONFIG_FILE")
if [ ! -n "$CONFIG_DATA" ]; then
    echo "Config file is empty, copying from template"
    cp /mnt/crystite/resonite.json $CONFIG_FILE
    CONFIG_DATA=$(grep -v " null," "$CONFIG_FILE")
fi
CONFIG_DATA=$(echo "$CONFIG_DATA" | jq ".comment = \"DO NOT EDIT: This file was automatically generated. Please edit $CONFIG_FILE instead.\"")
echo "{ \"Resonite\": $CONFIG_DATA }" > /etc/crystite/conf.d/_generated_resonite.json

## Setup Modloader Configs
if [ "$RESONITE_MOD_LOADER" == "true" ]; then
    echo  "Setting up Modloader Configs" 
    echo "{\"Resonite\": {\"pluginAssemblies\": [\"/data/resonite/Headless/Libraries/ResoniteModLoader.dll\"]}}" | jq '.' > /etc/crystite/conf.d/_generated_rml.json
    DEFAULT_RESONITE_ARGS=$(echo "$DEFAULT_RESONITE_ARGS -LoadAssembly /data/resonite/Headless/Libraries/ResoniteModLoader.dll")
else
    echo  "Modloader is disabled"
    rm -f /etc/crystite/conf.d/_generated_rml.json
fi