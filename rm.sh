#!/usr/bin/env bash

SRC_FILE=$(realpath "$1")
FILE=${SRC_FILE/$PWD\/src/$HOME}

gmv -v "$SRC_FILE" "$FILE" 
