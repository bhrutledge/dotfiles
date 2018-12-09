#!/usr/bin/env bash

FILE=$(realpath "$1")
SRC_FILE=${FILE/$HOME/$PWD\/src}
SRC_DIR=$(dirname "$SRC_FILE")

gmkdir -pv "$SRC_DIR" \
    && gcp -v "$FILE" "$SRC_FILE" \
    && gln -sfv "$SRC_FILE" "$FILE"
