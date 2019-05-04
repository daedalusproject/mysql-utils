#!/bin/bash -
#===============================================================================
#
#          FILE: 05-parse-options.sh
#
#   DESCRIPTION: Parses actions and tuns them

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 17:44
#===============================================================================

source lib/01-messages.sh
source lib/02-connection-variables.sh
source lib/03-test-connection.sh
source lib/04-change-root-password.sh

declare -a available_actions=(
'change_root_password'
)

function check_action {
    action=$1
    if [[ " ${available_actions[*]} " != *"$action"* ]]; then
        report_error "$action is not a valid action."
        exit 1
    fi
    MYSQL_UTILS_ACTION=$action
}

function parse_change_root_password_options {

    declare -a change_root_password_options_array=(
    "new-root-password"
    "new-root-host"
    )

    change_root_password_options="${change_root_password_options_array[*]}"
    change_root_password_options="${change_root_password_options/ /:,}:"
    change_root_password_options_OR="${change_root_password_options_array[*]}"
    change_root_password_options_OR="--${change_root_password_options_OR// /| --}"

    not_my_options=""
    OPTS=$(getopt --long "$change_root_password_options" -n 'change_root_password_options' --  "$@" 2> "$LOCAL_ERROR_FILE" )

    getopt_status=$?

    if [ $getopt_status -ne 0 ]; then
        error_msg=$( cat "$LOCAL_ERROR_FILE" )
        report_error "$error_msg"
        rm "$LOCAL_ERROR_FILE"
        exit 1
    fi

    eval set -- "$OPTS"

    while true; do
        eval "
        case $1 in
            $change_root_password_options_OR )
                set_mysql_variables $1 $2
                shift ; shift;;

            -- ) shift; break ;;
            * ) break ;;
        esac"
    done
}

function start_script {

    if [[ "$#" -lt 1 ]]; then
        report_error "'action' is required, see usage."
        exit 1
    fi

    check_action "$1"

    #Launch action
    parse_$MYSQL_UTILS_ACTION_options

}
