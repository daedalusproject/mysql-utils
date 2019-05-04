#!/bin/bash -
#===============================================================================
#
#          FILE: 04-change-root-password.sh
#
#   DESCRIPTION: Changes root password

#        AUTHOR: Álvaro Castellano Vela (alvaro.castellano.vela@gmail.com)
#  ORGANIZATION: Daedalus Project
#       CREATED: 03/05/2019 15:00
#===============================================================================

source lib/01-messages.sh

function check_new_root_password {
 if [[ -z $MYSQL_NEW_ROOT_PASSWORD ]]; then
     report_error "MYSQL_NEW_ROOT_PASSWORD is required."
     exit 1
 fi
}
