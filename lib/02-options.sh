#!/bin/bash -
#===============================================================================
#
#          FILE: 02-options.sh
#
#   DESCRIPTION: Manage variables

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

declare -a change_root_password_options_array=(
"new-root-password"
"new-root-host"
)

declare -a create_database_options_array=(
"database-name"
)

declare -a create_user_options_array=(
"new-user"
"new-user-password"
"new-user-host"
)

declare -a grant_options_array=(
"grant-priv-type"
"grant-user"
"grant-database"
"grant-host"
"grant-tables"
"grant-other-account-characteristics"
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

    eval "$(printf "%q=%q" "$variable_name" "$variable_value")"
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

function declare_change_root_password_options {

    change_root_password_options="${change_root_password_options_array[*]}"
    change_root_password_options="${change_root_password_options/ /:,}:"
    change_root_password_options_OR="${change_root_password_options_array[*]}"
    change_root_password_options_OR=$( echo "--$change_root_password_options_OR" | sed 's/ /| --/g' )
}

function declare_create_database_options {

    create_database_options="${create_database_options_array[*]}"
    create_database_options="${create_database_options/ /:,}:"
    create_database_options_OR="${create_database_options_array[*]}"
    create_database_options_OR=$( echo "--$create_database_options_OR" | sed 's/ /| --/g' )
}

function declare_create_user_options {

    create_user_options="${create_user_options_array[*]}"
    create_user_options="${create_user_options// /:,}:"
    create_user_options_OR="${create_user_options_array[*]}"
    create_user_options_OR=$( echo "--$create_user_options_OR" | sed 's/ /| --/g' )
}

function declare_grant_options {

    grant_options="${grant_options_array[*]}"
    grant_options="${grant_options// /:,}:"
    grant_options_OR="${grant_options_array[*]}"
    grant_options_OR=$( echo "--$grant_options_OR" | sed 's/ /| --/g' )
}

function get_variables {

    declare_connection_variables
    declare_change_root_password_options
    declare_create_database_options
    declare_create_user_options
    declare_grant_options

    long_options_OR="$long_connection_options_OR | $change_root_password_options_OR | $create_database_options_OR | $create_user_options_OR | $grant_options_OR"

    OPTS=$(getopt -o "$connection_options" --long "$long_connection_options,$change_root_password_options,$create_database_options,$create_user_options,$grant_options" -n 'options' -- "$@" 2> "$LOCAL_ERROR_FILE" )

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
            $long_options_OR )
                set_mysql_variables $1 $2
                shift ; shift;;

            -- ) shift; break ;;
            * ) break ;;
        esac"
    done
}
