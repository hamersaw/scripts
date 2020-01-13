#!/bin/bash

usage() {
    echo "Usage: $(basename $0) (-h | -o <hosts> -c <command> [-u <username>])
OPTIONS:
    -c      the command to execute
    -h      display this help menu
    -o      a list of hosts to execute on
    -u      host username to execute commands"
}

# retrieve opts
USERNAME=$(whoami)
while getopts ":c:ho:u:" opt; do
    case $opt in
        c )
            COMMAND=$OPTARG
            ;;
        h )
            usage
            exit 0
            ;;
        o )
            HOSTS=$OPTARG
            ;;
        u )
            USERNAME=$OPTARG
            ;;
        ? )
            usage
            exit 1
            ;;
    esac
done

# check if necessary variables are set
[[ -z "$COMMAND" ]] && echo "set command with '-c <command>'" && exit 1
[[ -z "$HOSTS" ]] && echo "set hosts with '-o <hosts>'" && exit 1

# iterate over hosts
for HOST in $HOSTS; do
    # execute command in background
    (OUTPUT=$(ssh $USERNAME@$HOST -n -o ConnectTimeout=500 $COMMAND 2>&1); \
        echo -e "--$HOST--\n$OUTPUT") &
done

# wait for all commands to complete
wait
