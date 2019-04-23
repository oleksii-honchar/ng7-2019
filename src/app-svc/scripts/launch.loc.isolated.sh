#!/usr/bin/env bash
envFile="../../devops/config/local.isolated.env"

env-cmd $envFile ./scripts/kill-node-zombies.sh
env-cmd $envFile ../../devops/local/scripts/check-env-vars.sh
env-cmd $envFile nodemon --inspect ./src/index.dev.js
