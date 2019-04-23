#!/usr/bin/env bash
baseDir=${PWD}
echo $baseDir
envFile="$baseDir/../../devops/config/production.env"
env-cmd $envFile ../../devops/local/scripts/check-env-vars.sh
env-cmd $envFile webpack --config ./webpack.config.js --mode production
