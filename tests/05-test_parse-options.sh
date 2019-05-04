#!/bin/bash -
#===============================================================================
#
#          FILE: 05-test_parse-options.sh
#
#   DESCRIPTION: Test options parsing

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 04/05/2019 16:56
#===============================================================================

source lib/05-parse-options.sh

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

testUnexistentAction() {

    cat << EOF > $TMP_FOLDER/nonexistenaction
Error: nonexistent is not a valid action.
EOF

    non_existent_action=$(check_action nonexistent 2> $TMP_FOLDER/nonexistenaction_test)
    non_existent_action_error=$?

    diff $TMP_FOLDER/nonexistenaction $TMP_FOLDER/nonexistenaction_test > /dev/null

    error_message_diff=$?

    assertEquals "1" "$non_existent_action_error"
    assertEquals "0" "$error_message_diff"
    assertEquals "" "$MYSQL_UTILS_ACTION"

}

testExistentAction() {
    check_action change_root_password
    existent_action_error=$?

    assertEquals "0" "$existent_action_error"
    assertEquals "change_root_password" "$MYSQL_UTILS_ACTION"
}


#
# Load shUnit2.
. /usr/bin/shunit2
