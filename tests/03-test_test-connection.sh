#!/bin/bash -
#===============================================================================
#
#          FILE: 03-test_test-connection.sh
#
#   DESCRIPTION: Test connection itself

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 05/01/2019 19:03
#===============================================================================

source lib/02-connection-variables.sh
source lib/03-test-connection.sh

oneTimeSetUp() {
    export TMP_FOLDER="/var/tmp/daedalus-project-mysql-utils/tests"
    mkdir -p $TMP_FOLDER
}

oneTimeTearDown() {
    rm -rf $TMP_FOLDER
}

setUp() {
    export LOCAL_ERROR_FILE="/var/tmp/daedalus-project-mysql-utils/error"
}

tearDown() {

    unset LOCAL_ERROR_FILE

    unset MYSQL_USER
    unset MYSQL_PASSWORD
    unset MYSQL_HOST
    unset MYSQL_PORT
    unset MYSQL_SOCKET
    unset MYSQL_CONNECTION_RETRIES
    unset MYSQL_CONNECTION_TIMEOUT
}

testNotAnyVariableSet() {


   cat << EOF > $TMP_FOLDER/notanyvariables
MYSQL_PASSWORD is required.
MYSQL_USER is required.
EOF

    check_connection_variables 2> $TMP_FOLDER/notanyvariables_test
    notanyvariables_errors=$?

    diff $TMP_FOLDER/notanyvariables $TMP_FOLDER/notanyvariables_test > /dev/null
    error_message_diff=$?
    assertEquals "1" "$notanyvariables_errors"
    assertEquals "0" "$error_message_diff"
}
#
# Load shUnit2.
. /usr/bin/shunit2
