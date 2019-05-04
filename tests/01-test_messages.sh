#!/bin/bash -
#===============================================================================
#
#          FILE: 01-test_debug.sh
#
#   DESCRIPTION: Test debug

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 18:46
#===============================================================================

source lib/01-messages.sh

TearDown() {
    unset DEBUG
}

testDebugNoMessage() {
    no_menssage=$(debug "This is a test")
    assertEquals "" "$no_menssage" #If debug options is not enabled no message is printed
}

testDebugWithMessage() {
    DEBUG=1
    expectedMessage="This is a test"
    menssage=$(debug "$expectedMessage")
    assertSame "$expectedMessage" "$menssage" #If debug options is  enabled message is printed
}

# Load shUnit2.
. /usr/bin/shunit2
