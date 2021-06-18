#!/bin/bash

if [[ -z $1 || ! -f "$1" ]]; then
	echo "enter file name to fetch quotes from i.e. ./quote.sh /path/to/quotes/file"
	echo "quotes file should be in the form: "
	echo "1. quote 1"
	echo "2. quote 2"
	echo "etc."
	exit 1
fi

DEBUG=0
if [[ ! -z $2 && "$2" -eq "debug" ]]; then
	DEBUG=1	
fi

FILE="$1"
LIM=`wc -l < $FILE | xargs`

debug() {
	if [[ $DEBUG == 1 ]]; then
		echo "$@"
	fi
}

debug "debug = $DEBUG, file = $FILE, limit = $LIM"
RANDOM=$$
RAND=$((${RANDOM} % ${LIM}))
debug "random: $RAND"
grep -e "^${RAND}. " $FILE | sed -E -e 's/[0-9]+\. //g'



