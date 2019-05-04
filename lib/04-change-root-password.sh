#!/bin/bash -
#===============================================================================
#
#          FILE: 04-change-root-password.sh
#
#   DESCRIPTION: Changes root password

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 03/05/2019 15:00
#===============================================================================

source lib/01-messages.sh

function check_new_root_password {
    has_errors=0
    for required_variable in 'MYSQL_NEW_ROOT_PASSWORD' 'MYSQL_NEW_ROOT_HOST'
    do
        if [[ -z ${!required_variable} ]]; then
            report_error "$required_variable is required."
            has_errors=1
        fi
    done
    if [[ $has_errors == 1 ]]; then
        exit 1
    fi
}

