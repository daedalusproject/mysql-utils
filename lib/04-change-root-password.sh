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
source lib/03-test-connection.sh

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

function change_root_password {

    check_new_root_password
    test_connection

    #test_connection creates $CONNECTION_STRING

    change_password_message=$(mysql $CONNECTION_STRING -Bse  "ALTER USER 'root'@'$MYSQL_NEW_ROOT_HOST' IDENTIFIED BY '$MYSQL_NEW_ROOT_PASSWORD';" 2>&1)

    change_passwod_status=$?

    if [[ $change_passwod_status != 0 ]]; then
        report_error "$change_password_message"
        exit 1
    fi
    exit 1
}
