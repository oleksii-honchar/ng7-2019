#!/usr/bin/env bash
envFile="../../devops/config/local.env"

env-cmd $envFile ./scripts/kill-node-zombies.sh
env-cmd $envFile ../../devops/local/scripts/check-env-vars.sh
env-cmd $envFile nodemon ./src/index.dev.js
