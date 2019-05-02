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

tearDown() {
    unset MYSQL_USER
    unset MYSQL_PASSWORD
    unset MYSQL_HOST
    unset MYSQL_PORT
    unset MYSQL_SOCKET
    unset MYSQL_CONECTION_RETRIES
    unset MYSQL_CONECTION_TIMEOUT
}

testNotConectionVariables() {
    no_conection=$(process_conection_variables 2> $TMP_FOLDER/process_conection_variables)
    no_variables_error=$?
    assertEquals "1" "$no_variables_error" #There is no variables.
}

# Load shUnit2.
. /usr/bin/shunit2
