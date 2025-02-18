#!/bin/bash

## PARAMS ################################################################################
PROJECT_NAME="$(. ./.env && echo ${PROJECT_NAME})"
COMPOSE_NAME=docker-compose_monitoring.yml

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
DIR_PROJECT=""

COMPOSE="docker-compose -f $DIR/$COMPOSE_NAME --env-file=$PROJECT_ROOT_DIR/.env --project-name $PROJECT_NAME --project-directory $DIR $1 $2"
echo -e "\n@@@@->$COMPOSE <-\n"

case $1 in
    up) $COMPOSE;;
    down) $COMPOSE;;
    *) "[ERROR] Comando NÃO Encontrado!!";;
esac