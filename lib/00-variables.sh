#!/bin/bash -
#===============================================================================
#
#          FILE: 00-variables.sh
#
#   DESCRIPTION: Global Variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 08/05/2019 18:09
#===============================================================================

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

