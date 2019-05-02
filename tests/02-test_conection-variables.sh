#!/bin/bash -
#===============================================================================
#
#          FILE: 02-test_conection-variables.sh
#
#   DESCRIPTION: Test connection variables

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 05/01/2019 19:03
#===============================================================================

source lib/02-conection-variables.sh

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
    unset MYSQL_CONECTION_RETRIES
    unset MYSQL_CONECTION_TIMEOUT
}

testDeclaredConectionOptions() {
    declare_conection_variables
    assertEquals "PShprtu" "$conection_options"
    assertEquals "-P | -S | -h | -p | -r | -t | -u" "$conection_options_OR"
    assertEquals "port,socket,host,password,retries,timeout,user" "$long_conection_options"
    assertEquals "--port| --socket| --host| --password| --retries| --timeout| --user" "$long_conection_options_OR"
}

# Load shUnit2.
. /usr/bin/shunit2
