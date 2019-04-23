#!/usr/bin/env bash
source ./devops/definitions.sh
source ./devops/local/scripts/load-env.sh
source ./devops/docker/scripts/login-to-registry.sh

envFile="./devops/config/local.env"
export $(grep -v '^#' $envFile | xargs)

docker-compose -f ./devops/docker/docker-compose/local.yml down
docker-compose -f ./devops/docker/docker-compose/local.yml up
