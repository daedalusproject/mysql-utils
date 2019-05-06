#!/bin/bash -
#===============================================================================
#
#          FILE: 07-test_grant.sh
#
#   DESCRIPTION: Test grant on user over database

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 06/05/2019 17:41
#===============================================================================

source lib/07-grant.sh

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
    unset MYSQL_NEW_USER_HOST

    unset MYSQL_GRANT_PRIV_TYPE
    unset MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS
    unset MYSQL_GRANT_USER
    unset MYSQL_GRANT_HOST
    unset MYSQL_GRANT_DATABASE
    unset MYSQL_GRANT_TABLES
}

testNoGrantData() {

    cat << EOF > $TMP_FOLDER/nograntdata
Error: MYSQL_GRANT_USER is required.
Error: MYSQL_GRANT_DATABASE is required.
EOF

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    $(check_grant 2> $TMP_FOLDER/nograntdata_test)
    no_grant_data_error=$?

    diff $TMP_FOLDER/nograntdata $TMP_FOLDER/nograntdata_test > /dev/null
    error_message_diff=$?
    assertEquals "1" "$no_grant_data_error"
    assertEquals "0" "$error_message_diff"
}

testGrantDataSet() {

    MYSQL_USER="roi000ot"
    MYSQL_PASSWORD="pAssw0rd"
    MYSQL_HOST="somerandomhost"
    MYSQL_PORT=3421
    MYSQL_SOCKET="/var/run/some/test.sock"
    MYSQL_CONNECTION_RETRIES=12
    MYSQL_CONNECTION_TIMEOUT=100

    #MYSQL_GRANT_PRIV_TYPE="ALL PRIVILEGES" by default
    #MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS="" by default
    MYSQL_GRANT_USER="testuser"
    #MYSQL_GRANT_HOST="%" by default 
    MYSQL_GRANT_DATABASE="newdatabase"
    #MYSQL_GRANT_TABLES="*" by default 

    check_grant
    check_grant_error=$?

    assertEquals "0" "$check_grant_error"
    assertEquals "ALL PRIVILEGES" "$MYSQL_GRANT_PRIV_TYPE"
    assertEquals "" "$MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS"
    assertEquals "testuser" "$MYSQL_GRANT_USER"
    assertEquals "%" "$MYSQL_GRANT_HOST"
    assertEquals "newdatabase" "$MYSQL_GRANT_DATABASE"
    assertEquals "*" "$MYSQL_GRANT_TABLES"
}

testGrantSelect() {
    MYSQL_USER="root"
    MYSQL_PASSWORD="letmein"
    MYSQL_HOST="percona-server"
    MYSQL_PORT=3306
    MYSQL_CONNECTION_RETRIES=5
    MYSQL_CONNECTION_TIMEOUT=1

    MYSQL_GRANT_PRIV_TYPE="SELECT"
    #MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS="" by default
    MYSQL_GRANT_USER="testuser"
    #MYSQL_GRANT_HOST="%" by default 
    MYSQL_GRANT_DATABASE="newdatabase"
    #MYSQL_GRANT_TABLES="*" by default 

    grant
    grant_error=$?

    assertEquals "0" "$grant_error"

    check_grant=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -Bse "SHOW GRANTS FOR '$MYSQL_GRANT_USER'@'$MYSQL_GRANT_HOST';" 2> /dev/null | grep \"$MYSQL_GRANT_USER\" | grep \"$MYSQL_GRANT_PRIV_TYPE\" > /dev/null)
    check_grant_error=$?
    assertEquals "0" "$check_grant_error"
}

testGrantAllPrivileges() {
    MYSQL_USER="root"
    MYSQL_PASSWORD="letmein"
    MYSQL_HOST="percona-server"
    MYSQL_PORT=3306
    MYSQL_CONNECTION_RETRIES=5
    MYSQL_CONNECTION_TIMEOUT=1

    MYSQL_GRANT_PRIV_TYPE="ALL PRIVILEGES"
    MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS="WITH GRANT OPTION"
    MYSQL_GRANT_USER="testuser"
    #MYSQL_GRANT_HOST="%" by default 
    MYSQL_GRANT_DATABASE="newdatabase"
    #MYSQL_GRANT_TABLES="*" by default 

    grant
    grant_error=$?

    assertEquals "0" "$grant_error"

    check_grant=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -Bse "SHOW GRANTS FOR '$MYSQL_GRANT_USER'@'$MYSQL_GRANT_HOST';" 2> /dev/null | grep "'$MYSQL_GRANT_USER'" | grep "'$MYSQL_GRANT_PRIV_TYPE'" | grep "'$MYSQL_GRANT_OTHER_ACCOUNT_CHARACTERISTICS'" > /dev/null)
    check_grant_error=$?
    assertEquals "0" "$check_grant_error"
}

#
# Load shUnit2.
. /usr/bin/shunit2
