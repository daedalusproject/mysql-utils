#!/bin/bash -
#===============================================================================
#
#          FILE: 08-parse-options.sh
#
#   DESCRIPTION: Parses actions and tuns them

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 17:44
#===============================================================================

source lib/01-messages.sh
source lib/02-variables.sh
source lib/03-test-connection.sh
source lib/04-change-root-password.sh
source lib/05-create-database.sh
source lib/06-create-user.sh
source lib/07-grant.sh

declare -a available_actions=(
'change_root_password'
'create_database'
'create_user'
'grant'
)

function check_action {
    action=$1
    if [[ " ${available_actions[*]} " != *"$action"* ]]; then
        report_error "$action is not a valid action."
        exit 1
    fi
    MYSQL_UTILS_ACTION=$action
}


function start_script {

    if [[ "$#" -lt 1 ]]; then
        report_error "'action' is required, see usage."
        exit 1
    fi

    check_action "$1"

    #Launch action
    get_variables "${@:1}"
    ${MYSQL_UTILS_ACTION}
}
