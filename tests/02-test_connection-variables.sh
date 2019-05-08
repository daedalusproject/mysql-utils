#!/bin/bash -
#===============================================================================
#
#          FILE: 02-test_connection-variables.sh
#
#   DESCRIPTION: Test connection variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 19:03
#===============================================================================

source lib/02-options.sh

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

testDeclaredconnectionOptions() {
    declare_connection_variables
    assertEquals "P:S:h:p:r:t:u:" "$connection_options"
    assertEquals "-P | -S | -h | -p | -r | -t | -u" "$connection_options_OR"
    assertEquals "port:,socket:,host:,password:,connection-retries:,connection-timeout:,user:" "$long_connection_options"
    assertEquals "--port| --socket| --host| --password| --connection-retries| --connection-timeout| --user" "$long_connection_options_OR"
}

testGetOpsEmpty(){
    declare_connection_variables
    get_variables
    empty_variables_error=$?
    assertEquals "0" "$empty_variables_error"
}

testInvalidOption(){
    declare_connection_variables
    empty_variable_error=$(get_variables --test="who cares" 2>&1)
    empty_variables_status=$?
    assertEquals "Error: options: unrecognized option '--test=who cares'" "$empty_variable_error"
    assertEquals "1" "$empty_variables_status"
}

testValidOption(){
    declare_connection_variables
    get_variables -u "root"
    valid_variable_error=$?
    assertEquals "0" "$valid_variable_error"
    assertEquals "root" "$MYSQL_USER"
}

testLongValidOption(){
    declare_connection_variables
    get_variables --user="root"
    valid_long_variables_status=$?
    assertEquals "" "$valid_long_variable_status"
    assertEquals "root" "$MYSQL_USER"
}

testLongValidOption2(){
    declare_connection_variables
    get_variables --connection-retries=2
    valid_long_variables_status=$?
    assertEquals "" "$valid_long_variable_status"
    assertEquals "2" "$MYSQL_CONNECTION_RETRIES"
}
#
# Load shUnit2.
. /usr/bin/shunit2
