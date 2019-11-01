#!/bin/bash

usage() {
    echo "Usage: $(basename $0) [-d <directory>]
OPTIONS:
    -h      display this help menu
    -d      output directory [default: '/tmp']"
}

# load commands from library
. library.sh

# check if applications are available
! inPath tar && echo "'tar' not found in users PATH" && exit 1

# retrieve opts
DIRECTORY="/tmp"
while getopts ":h" opt; do
    case $opt in
        h )
            usage
            exit 0
            ;;
        d )
            DIRECTORY=$OPTARG
            ;;
        ? )
            usage
            exit 1
            ;;
    esac
done

# execute
BACKUP_FILENAME="$DIRECTORY/$(hostname)-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf $BACKUP_FILENAME -C $HOME Desktop Documents
