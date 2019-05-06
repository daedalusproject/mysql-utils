#!/bin/bash -
#===============================================================================
#
#          FILE: 07-grant.sh
#
#   DESCRIPTION: Performs grant

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 06/05/2019 20:42
#===============================================================================

source lib/01-messages.sh
source lib/03-test-connection.sh

declare -A default_grant_options_hash=(
["MYSQL_GRANT_PRIV_TYPE"]=""
["MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS"]=""
["MYSQL_GRANT_HOST"]="%"
["MYSQL_GRANT_TABLES"]="*"
)

function set_unset_default_grant_variables {

    for default_variable in "${!default_grant_options_hash[@]}"
    do
        if [[ -z ${!default_variable} ]]; then
            eval "$default_variable=${default_grant_options_hash[$default_variable]}"
        fi
    done
}

function check_grant {
    set_unset_default_grant_variables
    has_errors=0
    for required_variable in 'MYSQL_GRANT_USER' 'MYSQL_GRANT_DATABASE'
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

function grant {

    check_grant
    test_connection

    #test_connection creates $CONNECTION_STRING

    grant_message=$(mysql $CONNECTION_STRING -Bse  "GRANT $MYSQL_GRANT_PRIV_TYPE ON '$MYSQL_GRANT_DATABASE'.'$MYSQL_GRANT_TABLES' TO '$MYSQL_GRANT_USER'@'$MYSQL_GRANT_HOST' $MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS;" 2>&1)

    grant_status=$?

    if [[ $grant_status != 0 ]]; then
        report_error "$grant_message"
        exit 1
    fi
}
