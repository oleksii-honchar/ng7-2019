#!/usr/bin/env bash
source ./devops/definitions.sh
source ./devops/local/scripts/load-env.sh
source ./devops/docker/scripts/login-to-registry.sh

envFile="./devops/config/local.isolated.env"
export $(grep -v '^#' $envFile | xargs)

docker-compose -f ./devops/docker/docker-compose/local.isolated.yml down
docker-compose -f ./devops/docker/docker-compose/local.isolated.yml up
