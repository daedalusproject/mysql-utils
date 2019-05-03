#!/bin/bash -
#===============================================================================
#
#          FILE: 03-test-connection.sh
#
#   DESCRIPTION: Tests connection variables and connection itself

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 03/05/2019 06:04
#===============================================================================

source lib/01-messages.sh
source lib/02-connection-variables.sh

declare -A default_connection_options_hash=(
["MYSQL_HOST"]="localhost"
["MYSQL_SOCKET"]="/var/run/mysqld/mysqld.sock"
["MYSQL_CONNECTION_RETRIES"]=5
["MYSQL_CONNECTION_TIMEOUT"]=10 # seconds
)

declare required_variables=(
"MYSQL_USER"
"MYSQL_PASSWORD"
"MYSQL_HOST"
#"MYSQL_PORT" - Not required
"MYSQL_SOCKET"
"MYSQL_CONNECTION_RETRIES"
"MYSQL_CONNECTION_TIMEOUT"
)

function set_unset_default_variables {

    for default_variable in "${!default_connection_options_hash[@]}"
    do
        if [[ -z ${!default_variable} ]]; then
            eval "$default_variable=${default_connection_options_hash[$default_variable]}"
        fi
    done
}

function check_connection_variables {
    set_unset_default_variables

    has_errors=0

    for variable_to_check in "${required_variables[@]}"
    do
        if [[ -z ${!variable_to_check} ]]; then
            report_error "$variable_to_check is required."
            has_errors=1
        fi
    done

    if [[ $has_errors == 1 ]]; then
        exit 1
    fi
}

