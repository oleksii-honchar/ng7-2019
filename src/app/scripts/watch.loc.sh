#!/usr/bin/env bash
envFile="$PWD/../../devops/config/local.env"
env-cmd $envFile "$PWD/../../devops/local/scripts/check-env-vars.sh"

source $envFile

if [ $SSR = true ]; then
    env-cmd $envFile npm run ng:build -- --watch &\
    env-cmd $envFile echo "SSR not implemented yet"
else
    env-cmd $envFile npm run ng:build -- --watch
fi
