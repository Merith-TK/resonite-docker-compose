#!/bin/bash

if [ "$STOP_LAUNCH" == "true" ]; then
    echo "STOP_LAUNCH is set to true, exiting..."
    exit 0
fi

# Check if Crystite is enabled 
if [ "$USE_CRYSTITE" == "true" ]; then
    echo "Running Crystite"
    /usr/lib/crystite/crystite
else 
    cd /data/headless/Headless || exit
    echo "Running Resonite"
    mono Resonite.exe $DEFAULT_RESONITE_ARGS $RESONITE_ARGS
fi