#!/bin/bash -
#===============================================================================
#
#          FILE: 02-conection-variables.sh
#
#   DESCRIPTION: Manage connection variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 19:05
#===============================================================================

function declare_conection_variables {

    declare -A conection_options_hash=(
    ["u"]="user"
    ["p"]="password"
    ["h"]="host"
    ["P"]="port"
    ["S"]="socket"
    ["r"]="retries"
    ["t"]="timeout"
    )

    conection_options=$( echo "${!conection_options_hash[@]}" | sed 's/ //g' )
    conection_options_OR=$( echo "${!conection_options_hash[@]}" | sed 's/\([^ ]\)/-\1 |/g' | sed 's/|$//g' | sed 's/[ ]*$//g' )

    long_conection_options=""
    for option in "${!conection_options_hash[@]}"
    do
        long_conection_options="$long_conection_options,${conection_options_hash[$option]}"
    done
    long_conection_options=$(echo "$long_conection_options" | sed 's/^,//g')
    long_conection_options_OR=$( echo "--$long_conection_options" | sed 's/,/| --/g' )
}

function get_conection_variables {
    OPTS=`getopt -o $conection_options --long $long_conection_options -n 'connection-options' -- "$@" 2> $LOCAL_ERROR_FILE `
}
