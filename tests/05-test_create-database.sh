#!/bin/bash -
#===============================================================================
#
#          FILE: 05-test_create-database.sh
#
#   DESCRIPTION: Test Change root password

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 13:01
#===============================================================================

source lib/03-test-connection.sh
source lib/05-create-database.sh

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

testNoDatabaseNameSet() {

    cat << EOF > $TMP_FOLDER/nodatabasename
Error: MYSQL_DATABASE_NAMED is required.
EOF

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    $(check_database_name 2> $TMP_FOLDER/nodatabasename_test)
    no_database_error=$?

    diff $TMP_FOLDER/nodatabasename $TMP_FOLDER/nodatabasename_test > /dev/null
    error_message_diff=$?
    assertEquals "1" "$no_new_password_error"
    assertEquals "0" "$error_message_diff"
}

testDatabaseNameSet() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100
    MYSQL_DATABASE_NAME="testdatabase"

    check_database_name
    new_password_error=$?

    assertEquals "0" "$new_password_error"
}

testCreateDatabase() {
    MYSQL_USER="root"
    MYSQL_PASSWORD="letmein"
    MYSQL_HOST="percona-server"
    MYSQL_PORT=3306
    MYSQL_CONNECTION_RETRIES=5
    MYSQL_CONNECTION_TIMEOUT=1
    MYSQL_DATABASE_NAME="newdatabase"

    create_database
    new_password_error=$?

    assertEquals "0" "$new_password_error"

    check_database_exists=$(mysql -uroot -pletmein -Bse "show databases" 2> /dev/null| grep test > /dev/null)
    check_database_error=$?
    assertEquals "0" "$check_database_error"
}

#
# Load shUnit2.
. /usr/bin/shunit2
