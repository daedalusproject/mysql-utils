#!/bin/bash -
#===============================================================================
#
#          FILE: 05-create-database.sh
#
#   DESCRIPTION: Creates databases

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 05/05/2019 19:43
#===============================================================================

source lib/01-messages.sh
source lib/03-test-connection.sh

function check_database_name {
    has_errors=0
    for required_variable in 'MYSQL_DATABASE_NAME'
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

function create_database {

    check_database_name
    test_connection

    #test_connection creates $CONNECTION_STRING

    create_database_message=$(mysql $CONNECTION_STRING -Bse  "create database $MYSQL_DATABASE_NAME;" 2>&1)

    create_database_status=$?

    if [[ $create_database_status != 0 ]]; then
        report_error "$create_database_message"
        exit 1
    fi
}
