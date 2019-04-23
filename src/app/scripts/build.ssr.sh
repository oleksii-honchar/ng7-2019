#!/usr/bin/env bash
envFile="$PWD/../../devops/config/production.env"
env-cmd $envFile "$PWD/../../devops/local/scripts/check-env-vars.sh"

env-cmd $envFile echo "SSR not implemented yet"
