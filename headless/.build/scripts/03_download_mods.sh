#!/bin/bash

## TOOOTTALLY NOT AI GENERATED NOTHING TO SEE HERE
# real note, this was because I normally program in
# golang and really, *really* didnt want to have to write
# and maintain a binary in a language many people dont
# want to use simply because google made it...
# shell scripts are typically known by docker hosters so...

# Define file URLs and their associated positions
file_urls=(
    "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll /data/resonite/Headless/Libraries/ResoniteModLoader.dll"
    "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/0Harmony.dll /data/resonite/Headless/rml_libs/0Harmony.dll"
)

# Function to download a file from URL to destination
download_file() {
    local url="$1"
    local destination="$2"
    # make sure destination directory exists
    mkdir -p "$(dirname "$destination")"
    # Use curl to download file
    if curl -fsSL "$url" -o "$destination"; then
        echo "File downloaded successfully: $destination"
    else
        echo "Failed to download file: $destination"
        exit 1
    fi
}

# Loop through each file URL and download
for file_url in "${file_urls[@]}"; do
    read -r url destination <<< "$file_url"
    # Backup existing file if exists
    if [ -f "$destination" ]; then
        mv "$destination" "${destination}.bak"
    fi
    # Download file
    download_file "$url" "$destination"
done

# Download additional files from a list of URLs to /data/resonite/Headless/rml_mods
# shellcheck disable=SC2153
for url in $MOD_URLS ; do
    destination="/data/resonite/Headless/rml_mods/$(basename "$url")"
    # Check if file already exists, if yes, skip download
    if [ ! -f "$destination" ]; then
        echo "Downloading mod: $url"
        download_file "$url" "$destination"
    fi
done

# if resonte mod loader is enabled, create and link rml_mods, libs, and config
if [ "$RESONITE_MOD_LOADER" == "true" ]; then
    for dir in rml_mods rml_libs rml_config; do
        if  [ -d "/data/resonite/$dir" ]; then
            continue
        fi
        mkdir -p "/data/resonite/Headless/$dir"
        ln -s "/data/resonite/Headless/$dir" "/data/resonite/$dir"
    done
    if [ ! -f "/data/resonite/Libraries/ResoniteModLoader.dll" ]; then
        mkdir -p "/data/resonite/Libraries"
        ln -s "/data/resonite/Headless/Libraries/ResoniteModLoader.dll" "/data/resonite/Libraries/ResoniteModLoader.dll"
    fi
fi