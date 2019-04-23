#!/usr/bin/env bash
envFile="$PWD/../../devops/config/local.env"
env-cmd $envFile "$PWD/../../devops/local/scripts/check-env-vars.sh"
source $envFile

env-cmd $envFile npm run ng:build -- --watch
