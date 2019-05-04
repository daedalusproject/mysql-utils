#!/bin/bash -
#===============================================================================
#
#          FILE: 02-connection-variables.sh
#
#   DESCRIPTION: Manage connection variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 05/01/2019 19:05
#===============================================================================

source lib/01-messages.sh

declare -A connection_options_hash=(
["u"]="user"
["p"]="password"
["h"]="host"
["P"]="port"
["S"]="socket"
["r"]="connection-retries"
["t"]="connection-timeout"
)

function set_short_mysql_variables {

    short_variable_name=$1
    short_variable_name=${short_variable_name//-/}
    short_variable_name=${connection_options_hash[$short_variable_name]}
    set_mysql_variables "$short_variable_name" "$2"
}

function set_mysql_variables {
    variable_name=${1//--/}
    variable_name=$( echo "MYSQL_$variable_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_' )
    variable_value=$2

    eval "$variable_name=$variable_value"
}

function declare_connection_variables {

    connection_options="${!connection_options_hash[*]}"
    connection_options="${connection_options// /:}:"
    connection_options_OR=$( echo "${!connection_options_hash[@]}" | sed 's/\([^ ]\)/-\1 |/g' | sed 's/|$//g' | sed 's/[ ]*$//g' )

    long_connection_options=""
    for option in "${!connection_options_hash[@]}"
    do
        long_connection_options="$long_connection_options,${connection_options_hash[$option]}"
    done
    long_connection_options=${long_connection_options/,/}
    long_connection_options_OR=$( echo "--$long_connection_options" | sed 's/,/| --/g' )
    long_connection_options="${long_connection_options//,/:,}:"
}

function get_connection_variables {
    OPTS=$(getopt -o "$connection_options" --long "$long_connection_options" -n 'connection-options' -- "$@" 2> "$LOCAL_ERROR_FILE" )

    getopt_status=$?

    if [ $getopt_status -ne 0 ]; then
        error_msg=$( cat "$LOCAL_ERROR_FILE" )
        report_error "$error_msg"
        rm "$LOCAL_ERROR_FILE"
        exit 1
    fi

    eval set -- "$OPTS"

    while true; do
        eval "
        case $1 in
            $connection_options_OR )
                set_short_mysql_variables $1 $2
                shift ; shift;;
            $long_connection_options_OR )
                set_mysql_variables $1 $2
                shift ; shift;;

            -- ) shift; break ;;
            * ) break ;;
        esac"
    done
}
