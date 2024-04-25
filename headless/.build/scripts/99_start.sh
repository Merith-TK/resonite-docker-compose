#!/bin/bash

if [ "$STOP_LAUNCH" == "true" ]; then
    echo "STOP_LAUNCH is set to true, exiting..."
    exit 0
fi

# Check if Crystite is enabled
if [ "$USE_CRYSTITE" == "true" ]; then
    echo "Running Crystite"
    echo "exec: /usr/lib/crystite/crystite"
    /usr/lib/crystite/crystite
else 
    cd /data/resonite/Headless || exit
    echo "Running Resonite"
    echo "exec: mono Resonite.exe $DEFAULT_RESONITE_ARGS $RESONITE_ARGS"
    mono Resonite.exe $DEFAULT_RESONITE_ARGS $RESONITE_ARGS
fi