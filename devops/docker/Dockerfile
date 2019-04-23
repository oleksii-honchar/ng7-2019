#--- BASE ---
FROM registry.ciklum.net/ciklum/skillum/wa-base-prod:2.2.0 AS release
CMD ["/etc/service/launch.sh"]
RUN mkdir -p /usr/src/web-app/dist
WORKDIR /usr/src/web-app

ARG NPM_REGISTRY
ARG NPM_REGISTRY_TOKEN
RUN mkdir /etc/service
ADD ./devops/docker/launch.sh /etc/service

#--- BUILD ---
FROM registry.ciklum.net/ciklum/skillum/wa-base-build:2.2.0 AS build
WORKDIR /tmp
ARG IS_CI_RUNNER
ARG NPM_REGISTRY
ARG NPM_REGISTRY_TOKEN

COPY ./devops/definitions.sh ./devops/definitions.sh
COPY ./devops/scripts/install-app.sh ./devops/scripts/install-app.sh
COPY ./devops/scripts/install-app-svc.sh ./devops/scripts/install-app-svc.sh
COPY ./src/app/package.json ./src/app/package.json
COPY ./src/app-svc/package.json ./src/app-svc/package.json

VOLUME npm-cache:/root/.npm
RUN npm set progress=true && npm config set depth 0 && \
    ./devops/scripts/install-app-svc.sh && \
    ./devops/scripts/install-app.sh

COPY ./package.json ./package.json
RUN npm i

COPY . .
RUN if [ "$LINT_WEB_APP" = "true" ]; then npm run web-app:lint; fi
RUN npm run app:build
RUN npm run app-svc:build

#--- FINAL---
FROM release AS final
WORKDIR /usr/src/web-app
COPY . .
RUN npm i
COPY --from=build /tmp/dist ./dist
