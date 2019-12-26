#!/usr/bin/env bash
# Move a file in ./src to $HOME

SRC_FILE=$(realpath "$1")
SRC_ROOT=$PWD/src

HOME_ROOT=${HOME_ROOT:-$HOME}
HOME_FILE=${SRC_FILE/$SRC_ROOT/$HOME_ROOT}

gmv -v "$SRC_FILE" "$HOME_FILE"
