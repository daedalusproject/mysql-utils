#!/bin/bash -
#===============================================================================
#
#          FILE: 08-usage.sh
#
#   DESCRIPTION: Shows usage

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 10/05/2019 06:19
#===============================================================================

function usage {

$CAT << EOF

Daedalus Poject's mysql-utils

The purpose of this is is avoid hardcodidng mysql commands inside Docker startup scripts.

Usage: daedalus-project-mysql-utils ACTION [ARGUMENTS]

When argumments are set and upercase like variables are set.
For example, setting --host="myhost" will set MYSQL_HOST to "myhost".

This script works with environment variables, if all required variables are set there is 
no need to set them using arguments.

Actions:
    usage:                                      Shows usage.
    change_root_password:                       Changes root's password.
    create_database:                            Creates databases.
    create_user:                                Creates users.
    grant:                                      Grants user access.

Arguments:

    Conection arguments:

    -u | --user=USER                            User wichs performs mysql connection.
                                                Sets MYSQL_USER

    -p | --password=PASSWORD                    User's password.
                                                Sets MYSQL_PASSWORD

    -h | --host=HOST                            Where msyql server is placed (localhost by default).
                                                Sets MYSQL_HOST

    -P | --post=PORT                            If this option is set this script uses host port for connections.
                                                Sets MYSQL_PORT  (default value is 3306)

    -S | --socket=SOCKET                        Socket to connect (/var/run/mysqld/mysqld.sock by default)
                                                Sets MYSQL_SOCKET

    -r | --connection-retries                   Number of times that this script tries to perfrom connection.
                                                Sets MYSQL_CONNECTION_RETRIES (default value is 5)

    -t | --connection-timeout                   Conection timeout in seconds
                                                Sets MYSQL_CONNECTION_TIMEOUT (default value is 10)


    change_root_password arguments:

    --new-root-password=PASS                    New root password
                                                Sets MYSQL_NEW_ROOT_PASSWORD

    --new-root-host                             root@'host'
                                                Sets MYSQL_NEW_ROOT_HOST

    create_database arguments:

    --database-name=NAME                        Name of the database to create
                                                Sets MYSQL_DATABASE_NAME

    create_user arguments:

    --new-user=NAME                             Name of the new user
                                                Sets MYSQL_NEW_USER

    --new-user-password=PASS                    Password of the new user
                                                Sets MYSQL_NEW_USER_PASSWORD

    --new-user-host=HOST                        New user's host
                                                Sets MYSQL_NEW_USER_HOST (% for example)

    grant arguments:

    --grant-priv-type=GRANT                     Grant priv type
                                                Sets MYSQL_GRANT_PRIV_TYPE (ALL PRIVILEGES by default)

    --grant-user=USER                           User to be granted
                                                Sets MYSQL_GRANT_USER

    --grant-database=DATABASE                   Database access to be granted
                                                Sets MYSQL_GRANT_DATABASE

    --grant-tables=TABLES                       Database tables to be granted
                                                Sets MYSQL_GRANT_TABLES (* by default)

    --grant-host=HOST                           User's host to be granted.
                                                Sets MYSQL_GRANT_HOST (% by default)

    --grant-other-account-characteristics=OTHER Extra characteristics
                                                Set MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS
EOF
}
