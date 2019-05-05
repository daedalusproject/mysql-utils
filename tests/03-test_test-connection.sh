#!/bin/bash -
#===============================================================================
#
#          FILE: 03-test_test-connection.sh
#
#   DESCRIPTION: Test connection itself

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 05/05/2019 19:03
#===============================================================================

source lib/02-variables.sh
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
Error: MYSQL_USER is required.
Error: MYSQL_PASSWORD is required.
EOF


notanyvariables=$(check_connection_variables 2> $TMP_FOLDER/notanyvariables_test)
notanyvariables_errors=$?

diff $TMP_FOLDER/notanyvariables $TMP_FOLDER/notanyvariables_test > /dev/null
error_message_diff=$?
assertEquals "1" "$notanyvariables_errors"
assertEquals "0" "$error_message_diff"
}

testDefaultValues() {

    MYSQL_USER="root"
    MYSQL_PASSWORD="password"

    check_connection_variables
    all_variables_errors=$?

    assertEquals "0" "$all_variables_errors"

    # Daefault values
    assertEquals "localhost" "$MYSQL_HOST"
    assertEquals "" "$MYSQL_PORT"
    assertEquals "/var/run/mysqld/mysqld.sock" "$MYSQL_SOCKET"
    assertEquals "5" "$MYSQL_CONNECTION_RETRIES"
    assertEquals "10" "$MYSQL_CONNECTION_TIMEOUT"

    # Set values
    assertEquals "root" "$MYSQL_USER"
    assertEquals "password" "$MYSQL_PASSWORD"
}

testChangeDefaultValues() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    check_connection_variables
    all_variables_errors=$?

    assertEquals "0" "$all_variables_errors"

    # Daefault values
    assertEquals "somerandomhost" "$MYSQL_HOST"
    assertEquals "3421" "$MYSQL_PORT"
    assertEquals "/var/run/some/test.sock" "$MYSQL_SOCKET"
    assertEquals "12" "$MYSQL_CONNECTION_RETRIES"
    assertEquals "100" "$MYSQL_CONNECTION_TIMEOUT"

    # Set values
    assertEquals "roi000ot" "$MYSQL_USER"
    assertEquals "pAssw0rd" "$MYSQL_PASSWORD"
}

testChangeDefaultValues() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    check_connection_variables
    all_variables_errors=$?

    assertEquals "0" "$all_variables_errors"

    # Daefault values
    assertEquals "somerandomhost" "$MYSQL_HOST"
    assertEquals "3421" "$MYSQL_PORT"
    assertEquals "/var/run/some/test.sock" "$MYSQL_SOCKET"
    assertEquals "12" "$MYSQL_CONNECTION_RETRIES"
    assertEquals "100" "$MYSQL_CONNECTION_TIMEOUT"

    # Set values
    assertEquals "roi000ot" "$MYSQL_USER"
    assertEquals "pAssw0rd" "$MYSQL_PASSWORD"
}

testTestConnectionFailed() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=1
    MYSQL_CONNECTION_TIMEOUT=1

    $(test_connection 2> /dev/null)
    failed_connection=$?

    assertEquals "1" "$failed_connection"
}

testTestConnectionFailedNoPort() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_CONNECTION_RETRIES=1
    MYSQL_CONNECTION_TIMEOUT=1

    $(test_connection 2> /dev/null)
    failed_connection=$?

    assertEquals "1" "$failed_connection"
}

testTestConnectionSuccess() {

    MYSQL_USER="root"
    MYSQL_PASSWORD="letmein"
    MYSQL_PORT=3306
    MYSQL_HOST="percona-server"
    MYSQL_CONNECTION_RETRIES=5
    MYSQL_CONNECTION_TIMEOUT=1

    test_connection 2> /dev/null
    failed_connection=$?

    assertEquals "0" "$failed_connection"
}

#
# Load shUnit2.
. /usr/bin/shunit2
