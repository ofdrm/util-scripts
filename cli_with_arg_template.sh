#! /bin/bash



usage() {
    error "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    error "enter /full/path as argument" 
    error "./cli_with_arg_template.sh -h     display help"
    error "./cli_with_arg_template.sh import -s path backup [-o path] unzip" 
    error "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    exit 1
}

SOURCE_PATH=""
SHOULD_BACKUP=0
BACKUP_PATH=""
SHOULD_UNZIP=0

validate() {
    : ${SOURCE_PATH:?"Missing SOURCE_PATH"}

    if [[ $SHOULD_BACKUP == 1 ]]; then
        : ${BACKUP_PATH:?"Missing BACKUP_PATH"}
    fi
}

run() {
    validate
    info "SOURCE_PATH=${SOURCE_PATH}"
    info "SHOULD_BACKUP=${SHOULD_BACKUP}"
    info "SHOULD_UNZIP=${SHOULD_UNZIP}"
    info "BACKUP_PATH=${BACKUP_PATH}"
}

init() {

    while getopts ":h" opt; do
        case ${opt} in
            h) 
                usage
                ;;
            :)
                error "option ${OPTARG} needs an argument"
                exit 1
                ;;
            \?|*) 
                error "invalid option ${OPTARG}"
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    subcommand=${1}
    shift

    case "$subcommand" in
        import)
            while getopts ":s:" opt; do
                case ${opt} in 
                    s)
                        SOURCE_PATH=${OPTARG}
                        ;;
                    :)
                        error "option ${OPTARG} needs an argument"
                        exit 1
                        ;;
                    \?|*) 
                        error "invalid option ${OPTARG}"
                        exit 1
                        ;;
                esac
            done
            shift $((OPTIND - 1))
            ;;
        backup)
            SHOULD_BACKUP=1
            while getopts ":o:" opt; do
                case ${opt} in
                    o)
                        BACKUP_PATH=${OPTARG}
                        ;;
                    :)
                        error "option ${OPTARG} needs an argument"
                        exit 1
                        ;;
                    \?|*) 
                        error "invalid option ${OPTARG}"
                        exit 1
                        ;;
                esac
            done
            shift $((OPTIND - 1))
            ;;
        unzip) 
            SHOULD_UNZIP=1     
            ;;
        : )
            error "option ${OPTARG} needs an argument"
            exit 1
            ;;
        \? ) 
            error "invalid option ${OPTARG}"
            exit 1
            ;; 
    esac
    shift $((OPTIND - 1))
    run
}

if [[ $# -eq 0 ]]; then
    usage
fi

init $@