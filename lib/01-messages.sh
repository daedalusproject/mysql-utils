#!/bin/bash -
#===============================================================================
#
#          FILE: 01-messages.sh
#
#   DESCRIPTION: Debug and error messages

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 18:46
#===============================================================================

if [[ -z $LOCAL_ERROR_FILE ]]; then
    LOCAL_ERROR_FILE="/var/tmp/daedalus-project-mysql-utils-error.log"
fi

function debug {

    if [ -n "$DEBUG" ]; then
        echo "$*"
    fi
}


function report_error {

    error_message="Error: $*"
    echo "$error_message" 1>&2
}
