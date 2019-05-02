#!/bin/bash -
#===============================================================================
#
#          FILE: 00-utils.sh
#
#   DESCRIPTION: utils

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 02/05/2019 21:44
#===============================================================================

function trim {
    echo "$1" | sed 's/^-*//'
}
