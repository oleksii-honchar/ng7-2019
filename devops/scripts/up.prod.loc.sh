#!/usr/bin/env bash
source ./devops/definitions.sh
source ./devops/local/scripts/load-env.sh
source ./devops/docker/scripts/login-to-registry.sh

envFile="./devops/config/production.env"
export $(grep -v '^#' $envFile | xargs)

docker-compose -f ./devops/docker/docker-compose/production.loc.yml down
docker-compose -f ./devops/docker/docker-compose/production.loc.yml up