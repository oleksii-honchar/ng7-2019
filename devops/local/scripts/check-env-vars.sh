#!/usr/bin/env bash

BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW=$(tput setaf 3)
NC='\033[0m' # No Color

function checkVar () {
    printf "$1 ";

    eval value='$'$1

    if [ -z "$value" ]
    then
        printf "${RED}[NOT FOUND]${NC}\n";
        return 1
    else
        printf "${GREEN}[OK]${NC}\n";
        return 0
    fi
}

printf "${LBLUE}Gonna check env vars...${NC}\n";

checkVar DOCKER_REGISTRY_USER
checkVar DOCKER_REGISTRY_PWD
checkVar DOCKER_REGISTRY_HOST

checkVar NPM_REGISTRY
checkVar NPM_REGISTRY_TOKEN

checkVar LOG_LEVEL

checkVar APP_SVC_PORT
checkVar APP_SVC_DEBUG_PORT
checkVar APP_SVC_MOUNT_POINT
checkVar APP_SVC_MODE
checkVar SVC_HOST
checkVar NODE_ENV
checkVar WATCH_MODE
checkVar SSR

printf "${LBLUE}Check completed${NC}\n";
