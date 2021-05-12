#! /bin/bash

FILE=$(basename $0)
DIR=$(dirname $0)
#echo "basename=$FILE, dirname=$DIR"

. $DIR/logging.sh

usage() {
	info "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	info "./unzip_import_all.sh -u -s /path/to/source"
	info "cd /path/to/source"
	info "chmod -R u+rx,go-w dir"
	info "./unzip_import_all.sh -i -s /path/to/source"
	info "./unzip_import_all.sh -c -s /path/to/source"
	info "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	exit 0
}


SOURCE_DIR=""
SHOULD_UNZIP=0
SHOULD_IMPORT=0
SHOULD_CLEAN=0

init() {
	while getopts ":hcuis:" opt; do
		case $opt in
			'h') usage;;
			's') SOURCE_DIR="$OPTARG";;
			'u') SHOULD_UNZIP=1;;
			'i') SHOULD_IMPORT=1;;
			'c') SHOULD_CLEAN=1;;
			:) error "option $OPTARG expects argument"; exit 1;;
			\?) error "invalid option $OPTARG"; exit 1;;
		esac
	done
	shift $((OPTIND - 1))

	info "SOURCE_DIR=$SOURCE_DIR, SHOULD_UNZIP=$SHOULD_UNZIP, SHOULD_IMPORT=$SHOULD_IMPORT, SHOULD_CLEAN=$SHOULD_CLEAN"
	: ${SOURCE_DIR:?"Missing SOURCE_DIR, did you specify -s?"}

	if [[ $SHOULD_UNZIP -eq 0 && $SHOULD_IMPORT -eq 0 && $SHOULD_CLEAN -eq 0 ]]; then
		error "specify at least -c, -u or -i option"
		exit 1
	fi

	cd "$SOURCE_DIR"

	for dir in *; do
		process_dir "$dir"
	done

	cd -
}

process_file() {
	if [[ ! -f "$1" ]]; then
		error "file not found $1"
		exit 1
	fi

	info "processing file $1"
	file=${1%.*}
	ext=${1##*.}
	info "filename: $file"
	info "ext: $ext"

	if [[ $SHOULD_UNZIP -eq 1 ]]; then
		info "unzipping $1"
		unzip "$1"
	fi

	if [[ $SHOULD_IMPORT -eq 1 ]]; then
		info "creating .git"
		mv "$file" ".git"
		info "cloning .git"
		git clone .git "$file"
		info "removing .git"
		rm -rf .git
	fi

	if [[ $SHOULD_CLEAN -eq 1 ]]; then
		info "removing file $1"
		rm -rf "$1"
	fi

	info "done processing file $1"
	
}

process_dir() {
	if [[ ! -d "$1" ]]; then
		error "directory not found $1"
		exit 1
	fi

	info "processing directory $1"
	cd "$1"
	for f in `ls *.zip`; do
		process_file "$f"
	done
	cd -
}


init "$@"
