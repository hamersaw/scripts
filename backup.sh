#!/bin/bash

usage() {
    echo "Usage: $(basename $0) [-d <directory>]
OPTIONS:
    -c <timestamp>  backup files since <timestamp> [ex. 201901011200]
    -h              display this help menu
    -o              output directory [default: '/tmp']"
}

# load configuration and command library scripts
. library.sh

# parse opts
OUTPUT_DIRECTORY="/tmp"
BACKUP_DIRECTORIES=("Desktop" "Documents" "Pictures")

while getopts "c:ho:" opt; do
    case $opt in
        c )
            CHANGE_TIMESTAMP="$OPTARG"
            ;;
        h )
            usage
            exit 0
            ;;
        o )
            OUTPUT_DIRECTORY=$OPTARG
            ;;
        ? )
            usage
            exit 1
            ;;
    esac
done

# check if applications are available
! inPath tar && echo "'tar' not found in users PATH" && exit 1

if [[ -z $CHANGE_TIMESTAMP ]]; then
    # initialize instance variables
    BACKUP_FILENAME="$OUTPUT_DIRECTORY/$USER-$(hostname)-$(date +%Y%m%d%H%M).tgz"

    # create a gzipped tar archive with all files
    tar -czf $BACKUP_FILENAME -C $HOME ${BACKUP_DIRECTORIES[*]}
else
    # initialize instance variables
    BACKUP_FILENAME="$OUTPUT_DIRECTORY/$USER-$(hostname)-$CHANGE_TIMESTAMP-$(date +%Y%m%d%H%M).tgz"
    TIMESTAMP_FILENAME="$OUTPUT_DIRECTORY/timestamp"
    MODIFIED_FILENAME="$OUTPUT_DIRECTORY/modified.txt"
    HOME_PREFIX_LEN=`echo "$HOME/" | wc -c`

    # find all files modified since CHANGE_TIMESTMAP
    touch -t $CHANGE_TIMESTAMP $TIMESTAMP_FILENAME
    for DIRECTORY in "${BACKUP_DIRECTORIES[@]}"; do
        find $HOME/$DIRECTORY -type f -newer $TIMESTAMP_FILENAME -print \
            | cut -c$HOME_PREFIX_LEN- >> $MODIFIED_FILENAME
    done

    # create a gzipped tar archive with modified files
    tar -czf $BACKUP_FILENAME -C $HOME `cat $MODIFIED_FILENAME`

    # clean up temporary files
    rm $TIMESTAMP_FILENAME $MODIFIED_FILENAME
fi
