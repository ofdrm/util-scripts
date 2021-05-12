#! /bin/bash

debug() {
    echo -e "$(date +'%d-%m-%Y %H:%M:%S:%3N')\tDEBUG\t$1"
}

info() {
    echo -e "$(date +'%d-%m-%Y %H:%M:%S:%3N')\tINFO\t$1"
}

error() {
    echo -e "$(date +'%d-%m-%Y %H:%M:%S:%3N')\tERROR\t$1" 1>&2
}
