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

declare -A default_grant_options_hash=(
["MYSQL_GRANT_PRIV_TYPE"]="ALL PRIVILEGES"
["MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS"]=""
["MYSQL_GRANT_HOST"]="%"
["MYSQL_GRANT_TABLES"]="*"
)

declare -a available_actions=(
'change_root_password'
'create_database'
'create_user'
'grant'
)
