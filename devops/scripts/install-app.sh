#!/usr/bin/env bash

BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    echo 'skip loading .env'

    if [[ -z "${NPM_REGISTRY}" ]] || [[ -z "${NPM_REGISTRY_TOKEN}" ]] ; then
        printf "${RED}[ERROR] NPM_REGISTRY or NPM_REGISTRY_TOKEN missed !!${RED}\n"
        exit 1
    fi
else
    if [[ -z "${NPM_REGISTRY}" ]] || [[ -z "${NPM_REGISTRY_TOKEN}" ]] ; then
        source ./devops/local/scripts/load-env.sh
    fi
fi

npm config set @ciklum:registry "https://${NPM_REGISTRY}"
npm config set "//${NPM_REGISTRY}/:_authToken" $NPM_REGISTRY_TOKEN

cd ./src/app
npm install