# scripts
## OVERVIEW
Repository of general-use scripts.

## SCRIPTS
- backup: backup script that creates tgz archives
- dotfiles: wrapper script for managing dotfiles using a git repository
- flash: terminal-based flash card store for studying
- spread: remotely execute a command on a cluster of hosts
- stash: encrypted hierarchical key-value store
- taskhammer: kanban board based task manager
- timehammer: schedule management script

## COMMANDS
    # dump stash <key, value> pairs
    for key in $(stash list); do stash get $key >> passwd; done

    # set stash password list from dump
    while read line; do read -r -a array <<< "$line"; \
        stash set "${array[0]}" "${array[2]}"; done <"passwd"

## TODO
