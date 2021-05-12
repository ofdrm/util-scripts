#! /bin/bash

FILE=$(basename $0)
DIR=$(dirname $0)
#echo "basename=$FILE, dirname=$DIR"

. $DIR/logging.sh
. $DIR/create_backup_folder.sh

validate() {
    debug "validating input"
    if [[ -z "$1" || ! -d "$1" ]]; then
        fatal "invalid directory $1"
    fi
}

backup() {
    validate $@
    backup_path=$(create_backup_folder)
    dir_to_backup="$1"

	info "backing up the directory $dir_to_backup to $backup_path"

	#cp -rv "$1" "$backup_path"/
}

backup $@