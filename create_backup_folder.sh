#! /bin/bash

FILE=$(basename $0)
DIR=$(dirname $0)
#echo "basename=$FILE, dirname=$DIR"

. $DIR/logging.sh

create_backup_folder() {
	backup_folder_name="backup_$(date +'%d-%m-%Y-%H-%M-%S')"
	backup_path="/tmp/backup/$backup_folder_name"
	mkdir -p "$backup_path"
    debug "created backup folder at $backup_path"
	echo $backup_path
}
