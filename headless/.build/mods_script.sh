#!/bin/bash

## TOOOTTALLY NOT AI GENERATED NOTHING TO SEE HERE
# real note, this was because I normally program in
# golang and really, *really* didnt want to have to write
# and maintain a binary in a language many people dont
# want to use simply because google made it...
# shell scripts are typically known by docker hosters so...

# Define file URLs and their associated positions
file_urls=(
    "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll /data/headless/Headless/Libraries/ResoniteModLoader.dll"
    "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/0Harmony.dll /data/headless/Headless/Libraries/rml_libs/0Harmony.dll"
)

# Function to download a file from URL to destination
download_file() {
    local url="$1"
    local destination="$2"
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
        echo "Backing up existing file: $destination"
        mv "$destination" "${destination}.bak"
    fi
    # Download file
    download_file "$url" "$destination"
done

# Download additional files from a list of URLs to /data/headless/Headless/rml_mods
IFS=',' read -r -a mod_urls <<< "$MOD_URLS"
for url in "${mod_urls[@]}"; do
    destination="/data/headless/Headless/rml_mods/$(basename "$url")"
    # Check if file already exists, if yes, skip download
    if [ -f "$destination" ]; then
        echo "File already exists: $destination. Skipping download."
    else
        # Download file
        download_file "$url" "$destination"
    fi
done
