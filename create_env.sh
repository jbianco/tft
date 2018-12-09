#!/bin/bash

#terraconf="-var-file=dev_env.tfvars"
terraconf=""
forced=false
## Color definitions ##
CSTDR="\033[0m"
CERR="\033[0;31m"
COK="\033[0;32m"
CWAR="\033[0;33m"
CDBG="\033[0;34m"

log(){
        echo -e $1
}

create_message(){
        message_type=$1
        message_color=$2
        message=$3
        echo "$message_color$(echo "$message_type"|awk '{print toupper($0)}'): $message$CSTDR"
}

info(){
        message=$1
        message_type="INFO"
        log "$(create_message $message_type $COK "$message")"
}

warn(){
        message=$1
        message_type="WARNING"
        log "$(create_message $message_type $CWAR "$message")"
}

error(){
        message=$1
        message_type="ERROR"
        log "$(create_message $message_type $CERR "$message")"
        exit 1
}

usage(){
    loglevel=$1
    $loglevel "Usage:"
    $loglevel "\t$0 [-c config file] [-d] [-f]"
    $loglevel "\t-c FILE\tUse a specific Terraform .tfvars config FILE"
    $loglevel "\t-d\tEnable terraform debug mode"
    $loglevel "\t-f\tForce apply without running plan"
}


while getopts "h?c:fd" opt; do
    case "$opt" in
    h|\?)
        usage "info"
        exit 0
        ;;
    c)  terraconf="-var-file=${OPTARG}"
        ;;
    d)  export TF_LOG=DEBUG
        ;;
    f)  info "Running terraform apply leaving out terraform plan"
        forced=true
        ;;
    esac
done



run() {
    cmd=$1
    info "$cmd"
    $cmd
}

if ! $forced
then
    run "terraform plan ${terraconf}"

    if [ $? -ne 0 ]
    then
        error "Terraform plan has failed, Please check the output before reexecuting it"
        exit 1
    fi
fi

run "terraform apply ${terraconf} -auto-approve"
