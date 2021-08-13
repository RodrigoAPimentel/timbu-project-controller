#!/bin/bash

## PARAMS ################################################################################
PROJECT_NAME="$(. ./.env && echo ${PROJECT_NAME})"
COMPOSE_NAME=docker-compose_tools.yml

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_PROJECT=""

COMPOSE="docker-compose -f $DIR/$COMPOSE_NAME --project-name $PROJECT_NAME --project-directory $DIR $1 $2"

## FUNCTIONS ################################################################################
findPathProject() {
    string=$DIR/
    myarray=()

    while [[ $string ]]; do
      myarray+=( "${string%%"/"*}" )
      string=${string#*"/"}
    done

    for i in $(seq 1 $((${#myarray[@]}-2)))
    do
      DIR_PROJECT+="/${myarray[$i]}"
    done
}

removeEnvFile() {
    if [ -f $DIR/.env ]; then
        rm $DIR/.env
    fi   
}

## INIT ######################################################################################
findPathProject

case $1 in
    up)
        removeEnvFile
        cp $DIR_PROJECT/.env $DIR/.env;
        $COMPOSE;;
    down)
        $COMPOSE
        removeEnvFile;;
    *) "[ERROR] Comando NÃO Encontrado!!";;
esac