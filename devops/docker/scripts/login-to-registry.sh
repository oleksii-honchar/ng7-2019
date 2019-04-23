#!/bin/bash
source ./devops/definitions.sh

docker login -u="$DOCKER_REGISTRY_USER" -p="$DOCKER_REGISTRY_PWD" $DOCKER_REGISTRY_HOST