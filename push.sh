#!/bin/bash

set -e

REPO_NAME=$(basename "$PWD")

if [ "$REPO_NAME" != "dotfiles" ]; then
    echo "Error: Current directory is not named 'dotfiles'"
    exit 1
fi

DEST="$HOME/.config/nvim"
SRC="$PWD/nvim"

if [ ! -d "$SRC" ]; then
    echo "Error: $SRC does not exist"
    exit 1
fi

rm -rf "$DEST"
cp -r "$SRC" "$DEST"
