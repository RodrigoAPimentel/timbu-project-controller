#!/bin/bash

## PARAMS ################################################################################
PROJECT_NAME="$(. ./.env && echo ${PROJECT_NAME})"

PARAM1=$1
PARAM2=$2
COMPOSE_DETACH=""
## INIT ######################################################################################
if [ $PARAM1 == "up" ]; then
    COMPOSE_DETACH="-d"
fi

echo -e "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>::<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo -e ">>>>>>>>>>> Executando docker-compose $PARAM1 $COMPOSE_DETACH ..... <<<<<<<<<<<"
echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>::<<<<<<<<<<<<<<<<<<<<<<<<<<<"

echo -e "\n>>>>> Executando [BACKEND] ..."
sh ../$PROJECT_NAME-backend/bin/docker-compose.sh $PARAM1 $COMPOSE_DETACH

echo -e "\n>>>>> Executando [FRONTEND] ..."
sh ../$PROJECT_NAME-frontend/bin/docker-compose.sh $PARAM1 $COMPOSE_DETACH

echo -e "\n>>>>> Executando [TOOLS] ..."
sh ./tools/docker-compose.sh $PARAM1 $COMPOSE_DETACH

if [[ $PARAM2 == "-m" || $PARAM1 == "down" ]]; then
    echo -e "\n>>>>> Executando [MONITORAMENTO] ..."
    sh ./monitoring/docker-compose.sh $PARAM1 $COMPOSE_DETACH
fi

echo -e "\n>>>>> Executando [NGINX] ..."
docker-compose --project-name $PROJECT_NAME $PARAM1 $COMPOSE_DETACH
