#!/usr/bin/env bash
set -e

cd /usr/src/web-app

if [[ "$NODE_ENV" == "development" ]]; then
    if [[ "$WATCH_MODE" == "true" ]]; then
        if [[ "$APP_SVC_MODE" == "normal" ]]; then
            /usr/bin/npm run web-app:launch:loc
        else
            /usr/bin/npm run web-app:launch:loc:isolated
        fi
    else
        if [[ "$APP_SVC_MODE" == "normal" ]]; then
            /usr/bin/npm run app-svc:launch:loc
        else
            /usr/bin/npm run app-svc:launch:loc:isolated
        fi
    fi
else
    /usr/bin/npm run app-svc:launch
fi
