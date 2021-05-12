#! /bin/bash

. ../logging.sh

if [[ -z "$1" ]]; then
	log "./extract /path/to/root/dir/of/source"
	exit 1
fi

init() {

	log "now processing root source directory $1"
	cd "$1"

	for dir in *; do
		process_dir "$dir"
	done

	cd -
}

process_file() {
	if [[ ! -f "$1" ]]; then
		log "file not found $1"
	fi

	log "processing file $1"
	file=${1%.*}
	ext=${1##*.}
	log "filename: $file"
	log "ext: $ext"
	log "unzipping $1"
	unzip "$1"
}

process_dir() {
	if [[ ! -d "$1" ]]; then
		log "directory not found $1"
		exit 1
	fi

	log "processing directory $1"
	cd "$1"
	for f in `ls *.zip`; do
		process_file "$f"
	done
	cd ..
}


init "$1"
