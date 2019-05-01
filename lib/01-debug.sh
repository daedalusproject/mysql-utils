#!/bin/bash -
#===============================================================================
#
#          FILE: 01-debug.sh
#
#   DESCRIPTION: Debug functions

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 01/05/2019 18:46
#===============================================================================


function debug {

    if [ -n "$DEBUG" ]; then
        echo "$@"
    fi
}
