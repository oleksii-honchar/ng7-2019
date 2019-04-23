#!/usr/bin/env bash

source ./devops/definitions.sh
source ./devops/ci/scripts/get-latest-version.sh

echo '---'
echo $ISSUE_ID
echo '---'

curl \
   -D- \
   -u $JIRA_USER \
   -X POST \
   --data "{ \"body\": \"{color:#14892c}*$CONTAINER_NAME@$VERSION*{color}\"}" \
   -H "Content-Type: application/json" \
   https://jira.ciklum.net/rest/api/2/issue/$ISSUE_ID/comment >/dev/null
