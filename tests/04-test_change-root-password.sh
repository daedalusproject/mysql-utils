#!/bin/bash -
#===============================================================================
#
#          FILE: 04-test_change-root-password.sh
#
#   DESCRIPTION: Test Change root password

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 13:01
#===============================================================================

source lib/04-change-root-password.sh

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

    unset MYSQL_NEW_ROOT_PASSWORD
    unset MYSQL_NEW_ROOT_HOST
}

testNoNewPasswordVariableSet() {

    cat << EOF > $TMP_FOLDER/nonewpassword
Error: MYSQL_NEW_ROOT_PASSWORD is required.
Error: MYSQL_NEW_ROOT_HOST is required.
EOF

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    $(check_new_root_password 2> $TMP_FOLDER/nonewpassword_test)
    no_new_password_error=$?

    diff $TMP_FOLDER/nonewpassword $TMP_FOLDER/nonewpassword_test > /dev/null
    error_message_diff=$?
    assertEquals "1" "$no_new_password_error"
    assertEquals "0" "$error_message_diff"
}

testNewPasswordVariableSet() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100
    MYSQL_NEW_ROOT_PASSWORD="somepass"
    MYSQL_NEW_ROOT_HOST="%"

    check_new_root_password
    new_password_error=$?

    assertEquals "0" "$new_password_error"
}


#
# Load shUnit2.
. /usr/bin/shunit2
