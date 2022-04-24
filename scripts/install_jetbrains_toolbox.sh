#!/bin/bash
# https://gist.github.com/greeflas/431bc50c23532eee8a7d6c1d603f3921
set -e

if [ -d ~/.local/share/JetBrains/Toolbox ]; then
    echo "JetBrains Toolbox is already installed!"
    exit 0
fi

echo "Start installation..."

wget --show-progress -qO ./toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"

TOOLBOX_TEMP_DIR=$(mktemp -d)

tar -C "$TOOLBOX_TEMP_DIR" -xf toolbox.tar.gz
rm ./toolbox.tar.gz

"$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox

rm -r "$TOOLBOX_TEMP_DIR"

echo "JetBrains Toolbox was successfully installed!"
