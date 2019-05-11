#!/bin/bash -
#===============================================================================
#
#          FILE: 06-create-user.sh
#
#   DESCRIPTION: Creates users

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 06/05/2019 06:18
#===============================================================================

source lib/01-messages.sh
source lib/03-test-connection.sh

function check_user {

    has_errors=0
    for required_variable in 'MYSQL_NEW_USER' 'MYSQL_NEW_USER_PASSWORD' 'MYSQL_NEW_USER_HOST'
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

function create_user {

    check_user
    test_connection

    #test_connection creates $CONNECTION_STRING

    create_user_message=$(mysql $CONNECTION_STRING -Bse  "CREATE USER '$MYSQL_NEW_USER'@'$MYSQL_NEW_USER_HOST' IDENTIFIED BY '$MYSQL_NEW_USER_PASSWORD';" 2>&1)

    create_user_status=$?

    if [[ $create_user_status != 0 ]]; then
        report_error "$create_user_message"
        exit 1
    fi
}
