#!/usr/bin/env bash
envFile="../../devops/config/production.env"

env-cmd $envFile ./scripts/kill-node-zombies.sh
env-cmd $envFile ../../devops/local/scripts/check-env-vars.sh
env-cmd $envFile node ../../dist/app-svc/bundle.js
