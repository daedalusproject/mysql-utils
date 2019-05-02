#!/bin/bash -
#===============================================================================
#
#          FILE: 02-connection-variables.sh
#
#   DESCRIPTION: Manage connection variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 19:05
#===============================================================================

source lib/01-messages.sh

function declare_connection_variables {

    declare -A connection_options_hash=(
    ["u"]="user"
    ["p"]="password"
    ["h"]="host"
    ["P"]="port"
    ["S"]="socket"
    ["r"]="connection-retries"
    ["t"]="connection-timeout"
    )

    connection_options=$( echo "${!connection_options_hash[@]}" | sed 's/ //g' )
    connection_options_OR=$( echo "${!connection_options_hash[@]}" | sed 's/\([^ ]\)/-\1 |/g' | sed 's/|$//g' | sed 's/[ ]*$//g' )

    long_connection_options=""
    for option in "${!connection_options_hash[@]}"
    do
        long_connection_options="$long_connection_options,${connection_options_hash[$option]}"
    done
    long_connection_options=$(echo "$long_connection_options" | sed 's/^,//g')
    long_connection_options_OR=$( echo "--$long_connection_options" | sed 's/,/| --/g' )
}

function get_connection_variables {
    OPTS=`getopt -o $connection_options --long $long_connection_options -n 'connection-options' -- "$@" 2> $LOCAL_ERROR_FILE `

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
  case \"$1\" in
    $connection_options_OR )
            echo $1
            shift ;;
    $long_connection_options_OR )
            echo $1
            shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac"
done

}
