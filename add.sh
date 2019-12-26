#!/usr/bin/env bash
# Copy an existing file in $HOME to ./src, then replace it with a symlink

HOME_FILE=$(realpath "$1")
HOME_ROOT=${HOME_ROOT:-$HOME}
# TODO: Exit if HOME_FILE isn't in HOME_ROOT

SRC_ROOT="$PWD/src"
SRC_FILE=${HOME_FILE/$HOME_ROOT/$SRC_ROOT}
SRC_DIR=$(dirname "$SRC_FILE")

gmkdir -pv "$SRC_DIR" \
    && gcp -v "$HOME_FILE" "$SRC_FILE" \
    && gln -sfv "$SRC_FILE" "$HOME_FILE"
