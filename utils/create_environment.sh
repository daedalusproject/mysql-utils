#!/bin/bash
#title           :create_environment.sh
#description     :This script creates Kubernetes environment for Daedalus Core pipelines.
#author          :Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>
#date            :20190423

## Variables

KUBERNETES_CONFIG_FOLDER="kubernetes"
KUBE_CLUSTER_CRT="$KUBERNETES_CONFIG_FOLDER/windmaker.pem"
## Functions

function show_error {

    echo "$@" 1>&2
}

### Check environment variables

function check_required_environment_variables {

    errors=0

    for environment_variable in "${REQUIRED_VARIABLES[@]}"
    do
        if [[ -z ${!environment_variable} ]]; then
            show_error "$environment_variable is not defined"
            errors=1
        fi
    done
    if [[ $errors == 1 ]]; then
        exit 1
    fi
}

function create_kube_config {

    kubectl config set-cluster default --server=$KUBERNETES_URL --certificate-authority=$KUBERNETES_CLUSTER_CRT
    kubectl config set-credentials $KUBERNETES_USER_NAME --token=$KUBERNETES_USER_TOKEN
    kubectl config set-context default --cluster=default --user=$KUBERNETES_USER_NAME
    kubectl config use-context default
}

function delete_configs {
    ls -lhart
    kubectl -n mysql-test delete -f kubernetes/services/database.yaml --ignore-not-found=true
}

function create_configs {

    kubectl -n mysql-test apply -f kubernetes/services/database.yaml --ignore-not-found=true
}

## Main

check_required_environment_variables
