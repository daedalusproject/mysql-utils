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

source lib/00-variables.sh
source lib/01-messages.sh
source lib/02-options.sh

function set_unset_default_variables {

    for default_variable in "${!default_connection_options_hash[@]}"
    do
        if [[ -z ${!default_variable} ]]; then
            eval "$(printf "%q=%q" "$default_variable" "${default_connection_options_hash[$default_variable]}")"
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

function test_connection {

    check_connection_variables

    CONNECTION_STRING="-u$MYSQL_USER -p$MYSQL_PASSWORD"
    if [[ "$MYSQL_PORT" != "" ]]; then
        CONNECTION_STRING="$CONNECTION_STRING -h $MYSQL_HOST -P $MYSQL_PORT"
    else
        CONNECTION_STRING="$CONNECTION_STRING -S $MYSQL_SOCKET"
    fi

    connection_error=1
    for retry  in $(seq 1 "$MYSQL_CONNECTION_RETRIES")
    do
        mysql $CONNECTION_STRING -Bse 'SELECT 1'  && connection_error=0 && break
        sleep "$MYSQL_CONNECTION_TIMEOUT"
    done

    if [[ $connection_error == 1 ]]; then
        report_error "Failed to connect after $retry retries."
        exit 1
    fi
}
