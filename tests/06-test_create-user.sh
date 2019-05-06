#!/bin/bash -
#===============================================================================
#
#          FILE: 06-test_parse-options.sh
#
#   DESCRIPTION: Test options parsing

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 16:56
#===============================================================================

source lib/06-create-user.sh

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

    unset MYSQL_DATABASE_NAME

    unset MYSQL_NEW_USER
    unset MYSQL_NEW_USER_PASSWORD
}

testNoNewUserDataSet() {

    cat << EOF > $TMP_FOLDER/nonewuserdata
Error: MYSQL_NEW_USER is required.
Error: MYSQL_NEW_USER_PASSWORD is required.
Error: MYSQL_NEW_USER_HOST is required.
EOF

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    $(check_new_user 2> $TMP_FOLDER/nonewuserdata_test)
    no_user_data_error=$?

    diff $TMP_FOLDER/nonewuserdata $TMP_FOLDER/nonewuserdata_test > /dev/null
    error_message_diff=$?
    assertEquals "1" "$no_user_data"
    assertEquals "0" "$error_message_diff"
}

testNewUserDataSet() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    MYSQL_NEW_USER="testuser"
    MYSQL_NEW_USER_PASSWORD="secretpassword"
    MYSQL_NEW_USER_HOST="%"

    check_new_user
    new_user_error=$?

    assertEquals "0" "$new_user_error"
}

testCreateNewUser() {
    MYSQL_USER="root"
    MYSQL_PASSWORD="letmein"
    MYSQL_HOST="percona-server"
    MYSQL_PORT=3306
    MYSQL_CONNECTION_RETRIES=5
    MYSQL_CONNECTION_TIMEOUT=1

    MYSQL_NEW_USER="testuser"
    MYSQL_NEW_USER_PASSWORD="secretpassword"
    MYSQL_NEW_USER_HOST="%"

    create_new_user
    create_new_user_error=$?

    assertEquals "0" "$create_new_user_error"

    check_user_exists=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -Bse "select 1 from mysql.user WHERE User='$MYSQL_NEW_USER' AND Host='$MYSQL_NEW_USER_HOST';" 2> /dev/null | grep 1 > /dev/null)
    check_user_exists_error=$?
    assertEquals "0" "$check_database_error"
}

#
# Load shUnit2.
. /usr/bin/shunit2
