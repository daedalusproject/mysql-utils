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

source lib/06-parse-options.sh

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

testChangeRootPasswordOptions() {
    declare_change_root_password_options
    get_variables --new-root-password="test"

    assertEquals "--new-root-password| --new-root-host" "$change_root_password_options_OR"
}

testLaunchWithoutOptions() {
    error_message=$(start_script 2>&1)
    error_code=$?

    assertEquals "Error: 'action' is required, see usage." "$error_message"
    assertEquals "1" "$error_code"
}


testLaunchChangeRootPasswordWithInvalidOptions() {
    error_message=$(start_script change_root_password --non-existent-option="thisisatest" 2>&1)
    error_code=$?

    assertEquals "Error: options: unrecognized option '--non-existent-option=thisisatest'" "$error_message"
    assertEquals "1" "$error_code"
}

testLaunchChangeRootPasswordWithoutRequiredOptions() {
    cat << EOF > $TMP_FOLDER/changepasswordnooptions
Error: MYSQL_NEW_ROOT_PASSWORD is required.
Error: MYSQL_NEW_ROOT_HOST is required.
EOF


    error=$(start_script change_root_password 2> $TMP_FOLDER/changepasswordnooptions_test)
    error_code=$?
    diff $TMP_FOLDER/changepasswordnooptions $TMP_FOLDER/changepasswordnooptions_test > /dev/null

    error_message_diff=$?

    assertEquals "0" "$error_message_diff"
    assertEquals "1" "$error_code"
}

testLaunchChangeRootPasswordWithoutRequiredConnectionOptions() {
    cat << EOF > $TMP_FOLDER/changepasswordnoconnectionoptions
Error: MYSQL_USER is required.
Error: MYSQL_PASSWORD is required.
EOF

    MYSQL_NEW_ROOT_HOST="localhost"
    error=$(start_script change_root_password --new-root-password="newpass" 2> $TMP_FOLDER/changepasswordnoconnectionoptions_test)
    error_code=$?

    diff $TMP_FOLDER/changepasswordnoconnectionoptions $TMP_FOLDER/changepasswordnoconnectionoptions_test > /dev/null
    error_message_diff=$?

    assertEquals "0" "$error_message_diff"
    assertEquals "1" "$error_code"
}

testCreateDatabase() {
    start_script create_database --database-name="otherdatabase" -uroot -pletmein -P3306 --host="percona-server"
    new_database_error=$?

    assertEquals "0" "$new_database_error"
}

testLaunchChangeRootPassword() {
    start_script change_root_password --new-root-password="newpass" --new-root-host="%" -uroot -pletmein -P3306 --host="percona-server"
    new_password_error=$?

    assertEquals "0" "$new_password_error"
}

testLaunchRestoreRootPassword() {
    start_script change_root_password --new-root-password="letmein" --new-root-host="%" -uroot -pnewpass -P3306 --host="percona-server"
    restore_password_error=$?

    assertEquals "0" "$restore_password_error"
}

#
# Load shUnit2.
. /usr/bin/shunit2
