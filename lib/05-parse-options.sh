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
