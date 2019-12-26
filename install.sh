#!/usr/bin/env bash
# Create symbolic links in $HOME to all files in ./src
# Inspired by https://unix.stackexchange.com/questions/196537/how-to-copy-a-folder-structure-and-make-symbolic-links-to-files

SRC_ROOT=$PWD/src
HOME_ROOT=${HOME_ROOT:-$HOME}

gcp -asTv "$@" "$SRC_ROOT" "$HOME_ROOT"
