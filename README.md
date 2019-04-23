# DF2 Web-app cmp: APP-SVC (node.js) + APP(SPA)

`Web application` component which consist of `app-svc` and SPA `app`

<!-- toc -->
- [Overview](#overview)
	* [How to read diagram](#how-to-read-diagram)
	* [Diagram notes](#diagram-notes)
- [Repo structure](#repo-structure)
	* [Folder/files structure](#folderfiles-structure)
- [Local env](#local-env)
	* [Preparation](#preparation)
		+ [ENV variables](#env-variables)
			- [.env](#env)
			- [./devops/config/local](#devopsconfiglocal)
	* [Web-app](#web-app)
		+ [Dependencies](#dependencies)
		+ [Scripts](#scripts)
		+ [App-svc](#app-svc)
			- [Isolation mode](#isolation-mode)
		+ [App](#app)
		+ [Server side rendering](#server-side-rendering)
			- [Query params](#query-params)
	* [Docker](#docker)
		+ [Hosts](#hosts)
- [CI/CD](#cicd)
- [Troubleshooting for Windows OS](#troubleshooting-for-windows-os)
	+ [Docker](#docker-1)
	+ [Pre-commit hooks](#pre-commit-hooks)
- [Links](#links)

<!-- tocstop -->

# Overview
General `web-app` structure is intended to be as close as possible to production runtime. It is docker & gitlab based considering df2 approach. It contains gitignored configs to reach remote services and development fake creds to run configureless images considering security policies. 

![](https://gitlab.ciklum.net/st/delivery-framework/raw/master/lvl2/components/assets/df2-cmp-web-app.jpg)

## How to read diagram

You have to read diagram from left to right. 

First block illustrate repo file struture. And what kind of config it contains:

- local nginx config - to run `web-app` container locally
- docker-compose config - to combine `service` with `web-app` locally
- gitlab-ci config - to setup pipeline jobs config for `web-app`
- docker config - to build `web-app` image locally and via ci jobs
- ./devops/.. - bash scripts and configs to build and run in local & isolated mode `web-app` locally and via gitlab-runner

Second block shows how this configuration runs on local workstation:

- gitignored `.env` file used
- local config used
- docker-compose starts all necessary containers and connect local sources to the `web-app` container. Which is previously built (`npm run docker:build` at least once). Use `npm run docker:up:loc` for watching changes.
- under the hood the `npm run web-app:launch:dev` is used to monitor changes. It works even under the docker
- `web-app` is available from Chrome via docker-compose containers

Last block describes how the CI/CD pipeline works:

- After new branch pushed and merge-requested created `build-only` job automatically started to check image build
- When merge-request merged `bump-version` job automatically started to update version according to MR title key word (patch/minor/major)
- When new tag appear on master then `build-and-push` job automatically started to build and push new image. On success `deploy-dev` job started to deploy your code to dev env. After you can manually deploy it on qa -> stage -> prod

## Diagram notes

**(1)** `.env` file used for local build & laucnh. It contains creds to remote services and should be gitignored

**(2)** local config with app settings is used by `npm` script. This script can be used on host machine without docker. Same script will be executed by docker when `run.*.sh` used

**(3)** `app-svc` itself available on `:8000` port without docker. And it is a part of `web-app` container

**(4)** `app` js files is a part of `web-app` container builded and bundled in image. Or for dev scripts they are build in runtime by `webpack`

# Repo structure

Repo contains such parts:

- config
	- remote services creds (docker & npm registry, .env gitignored)
	- development fake config (normal & isolated not used for stage & prod)
- docker config
	- build & run images locally
	- bundle nginx & app-svc & static assets together
- gitlab ci/cd pipeline config
- devops folder with helper scripts to manage docker, gitlab and jobs

## Folder/files structure
- **/devops** - manual/auto deploy/build scripts/configs
	- **ci/scripts** - gitlab ci jobs and scripts
	- **/config** -  dev env config
		- **local.env**
		- **loca.isolated.env**
		- **production.local.env**
  - **/docker** - docker related scripts/configs
		- **/docker-compose** - local, isolated & prod.local configs
		- **/scripts** - helpers
		- **/services** - runit service setup
			- **/web-app** - web-app run-it setup
      - **Dockerfile** - main config to build `api-gw` + `app`
	- **/local** - only for local development
		- **/scripts** - general purpose scripts
		- **nginx** - development env nginx config
	- **definitions.sh** - docker names config
 - **/dist** - all binaries should be here
	   - **app-svc** - `app-svc` binaries for prod
	   - **static** - `app` binaries with assets
 - **/src** - source code
      - **/app-svc** - api-gw sorce code
      - **/app** - web application source code
 - **package.json** - component meta file (default for js environment). Here the whole `web-app` version history is tracked

# Local env

Web-app consist of two main parts:

- `App-svc` - express.js headless application it implement such features:
	- provide app-friendly interface (not binded to `service` business logic)
	- serve static file in development mode
	- provide server-side render service
	- implement `isolated` & `normal` mode to work with `service` app
	- implement schema mapper to adopt `service` business logic to convenient `app` format
- `App` - SPA application

## Preparation

### ENV variables

#### .env

- REGISTRY_USER - docker registry user
- REGISTRY_PWD - docker registry pwd
- REGISTRY_HOST - docker registry host
- NPM_REGISTRY_USER - private npm registry user (project related)
- NPM_REGISTRY_PWD - private npm registry pwd
- NPM_REGISTRY_EMAIL - private npm registry host (npm.pp.ciklum.com)

#### ./devops/config/local

This vars used for local execution only and cannot affect production

- LOG_LEVEL=info -  can be `debug/info/warn/error` - defines level of logs for `api-gw` & `app`
- APP_SVC_PORT=8000 - default port for api-gw
- APP_SVC_MOUNT_POINT=/api
- APP_SVC_MODE=normal - can be `normal/isolated`
- SERVICE_HOST=http://service - default url for working via docker
- NODE_ENV=development
- WATCH_MODE=true - used in docker run script to watch sorces in delopment mode

## Web-app

![](https://gitlab.ciklum.net/st/delivery-framework/raw/master/lvl2/components/assets/df2-cmp-web-app-app-svc.jpg)

After user reaches `app` in chrome(e.g.) such SPA logic used:

- Every module(not dumb component) has its own state(via redux) actions and effects via [@ciklum/exo](https://gitlab.ciklum.net/solutionsjs/module-exo)
- Actions can interconnect via [@ciklum/raax](https://gitlab.ciklum.net/solutionsjs/module-raax) with [@ciklum/xmess](https://gitlab.ciklum.net/solutionsjs/module-xmess) built-int async messaging protocol
- when component needs some data it uses [@ciklum/waas](https://gitlab.ciklum.net/solutionsjs/module-waas) to make requests to `api-gw`

When `app-svc` received request for tha data such things happened:

- every component nesting are reflected by routing nesting 1-1. So it is become very easy to understand with routes should be used for particualr component data
- routes handlers uses `service-mapper` to receive/validate and finally map `service` data to `app` schemas
- `app` schemas stored separatelly and designed to fullfill `app` expectations
- `service` schemas should reflect actual swagger docs of actual service version
- `service-mapper` layer give ability to map freely service data to app format
- `/` route is default route to serve app html. This route is used under the hood when docker and api-gw launched. The most important feature of this route is to serve server-side-rendered content using `render-mode` query param.

### Dependencies

  - node@^10 - please install `node-js` on your machine using [nvm](https://github.com/creationix/nvm)

When you clone the repo execute such scripts:

```
-> /web-app$ npm run web-app:install
-> /web-app$ ./deploy/develop/scripts/chmod-scripts.sh

```

First line will install all modules for `app-svc` & `app`. Second one will make all necessary script to be executable.

### Scripts

There are default scripts in top level `package.json`:

- `docker:build` - invoke build scripts from `./devops/..` to build docker image
- `docker:up:prod:loc` - using prod.local cfg docker-compose up local production like container. Bundled binaries used only. No watch option.
- `docker:up:loc` - using local cfg docker-compose up local development container. Local src used in watch mode. On windows file system issues can be experienced.
- `docker:up:loc:isolated` - same as `docker:up:loc` but `app-svc` in isolated mode - no request made to `svc`
- `web-app:launch:loc` - launch `app-svc`(`normal` mode) and `app` in watch mode and connect with `service`. No docker used. Convenient for windows and fast local development. Before branch merge docker build and check necessary.
- `web-app:launch:loc:isolated` - launch `app-svc`(`isolated` mode) and `app` in watch mode. 
- `web-app:install` - install `app-svc` & `app` deps
- `web-app:lint` - lint `app-svc` & `app` in parallel
- `web-app:lint:fix` - fix lint issues for `app-svc` & `app` in parallel
- `app-svc:launch:loc` - launch `app-svc` in `normal` mode
- `app-svc:launch:loc:isolated` - launch `app-svc` in `isolated` mode
- `app-svc:launch:prod:loc` - launch `app-svc` in `normal` `production.local` mode
- `app-svc:launch` - launch `app-svc` in `production.local` mode
- `app-svc:build` - build `app-svc` binaries
- `app-svc:build:loc` - build `app-svc` development binaries
- `app-svc:test` - launch `app-svc` in test
- `app-svc:lint` - launch `app-svc` lint
- `app-svc:lint:fix` - fix lint issues for `app-svc`
- `app-svc:install` - install `app-svc` deps
- `app:build` - build `app` binaries in `production` mode
- `app:build:loc` - build `app` binaries in `development` mode
- `app:watch` - run `app` watcher
- `app:lint` - launch `app` lint
- `app:lint:fix` - fix lint issues for `app`
- `app:test` - launch `app` tests
- `app:install` - install `app` deps 

Please read the corresponding `package.json` file to check them.

### App-svc

It's express.js based application which implements [api-gateway pattern](microservices.io/patterns/apigateway.html). Its purpose is to make `service` and web `app` less coupled. So when `app` make request, `app-svc` orchestrate it to proper `service` resources. Then `app-svc` map data from `service` schemas to `app` schemas.

Second purpose of `app-svc` is to serve static files of `App`. There is deafult endpoint: `/` - it used to server app's `index.html`. Additional query params can be passed through it to be processed by `app-svc` or `app`.

Also server-side rendering is made by `app-svc`. Additional bundles should bу used (at least for rect)

#### Isolation mode

There is `APP_SVC_MODE` variable exists. There is two possible modes:

- `isolated` - all requested from `app-svc` to `service` are mocked and mock data processed by `api-gw` route handlers
- `normal` - all requests to `service` executed via http

Please check exisiting config files in `./devops/config/*.env`.


### App

It's normal SPA. It's executed in browser and make request to its origin(`app-svc`) or directly to `service`.

- [React SPA styleguide](https://gitlab.ciklum.net/st/delivery-framework/blob/master/lvl2/components/react-app-styleguide.md)
- [AngularJS SPA styleguide](https://gitlab.ciklum.net/st/delivery-framework/blob/master/lvl2/components/angular-js-app-styleguide.md)

### Server side rendering

![](https://gitlab.ciklum.net/st/delivery-framework/raw/master/lvl2/components/assets/df2-cmp-web-app-ssr.jpg)

<details>
<summary>Diagram description ...</summary>

<p>(1) When browser make request to web-app url it resolved by docker container. Nginx | Load balancer can be before it. 
<br><br>
Incoming request forwarded to node.js app-svc. It is parsed by router and handled by RootHandler function

<p>(2) Final html response with ssr html and intial state (base64) sent to browser

<p>(3) Server-side render service is invoked to render SPA app. Ssr bundle is used interally with specific export - used to render SPA on server-side.

<p>(4) Since raax wrapper used to organise ui logic its interfaces used to bootstrap state. <br><br>

Effects section is used to manually setup app logic inheritance. It is preparation phase. Action section - to fetch/process data.  Ssr section is used to tell api-gw wich action should be called to get all necessary data when rendered on server. Ssr section actions will be called after bootstraping state. 

<p>(4.1) Behind raax wrapper common react + redux + mui-css app structure exists

<p>(5) bootstrapState() - This phase used to prepare state manually. Parse routes, fetch/check i18n, etc. After this state passed to bootstrapApp() where first render happened. After first render redux app-state is populated by raax-ssr actions. They tell us which additional actions should be called to populate state for full render. After their asyn execution second(final) render performed. Now state fully populated and html is rendered.

<p>(6) After all async actions executed, state populated and html rendered all all this data returned to ssr-service along with styles.

<p>(7) Ssr-service prepare data to render index.html template with app html, state and styles. This template fills the `window.config` global var.


<p>(8) After ssr html received and displayed, browser make request for browser bundle. It is normal SPA bundle to be executed in browser.

<p>(9) Actually browser bundle is adopted to use ssr data. First it not render() but hydrate() existing html (from ssr). Also it parses window.config.intialState and feed browser reducers with it. 

</details>

#### Query params

This query params can be added to url to control render mode and app start:

- `render-mode` - `normal|no-ssr` - by default `normal` `render-mode` is used. In this mode ssr-service used to render app html and populate state on server-side
- `start-app` - `true|false` - by default `start-app=true` and app started when loaded. When you need to check ssr - you can turn it false to see pure ssr result

## Docker

We considering web-app to be used on production in docker. So we need to be as close as possible to that setup on every developer machine. That's why it is better to develop using docker setup.

There are couple of scripts to work with docker:

- `npm run docker:build` - build locally `web-app` docker image. You need to build it at least once before to run it.
- `npm run docker:up:prod:loc` - run web-app docker image with `production.local` fake config
- `npm run docker:up:loc`- run web-app docker image with `development` config and attached sources of `app-svc` & `app` in watch mode. So you can develop your code in IDE and it will be served via docker to browser
- `npm run docker:up:loc;isolated` - same as before, but `app-svc` executed in `isolated` mode. This mode good to use when `service` app unstable or lack of necessary features

**Notes**:
- For Windows users [git bash](https://git-scm.com/download/win) is required to work with scripts 

### Hosts

In order to use similar url for every env you need to add this refs in your `etc/hosts` file:

```
127.0.0.1 svc-loc.PROJECT_NAME.pp.ciklum.com
127.0.0.1 loc.PROJECT_NAME.pp.ciklum.com
```

# CI/CD
Please follow [DF2 DevOps](https://gitlab.ciklum.net/st/delivery-framework/blob/master/lvl2/dev-ops.md) in general and for commits and branches in paticular. 

There are 3 main pipleines exist considering df2 convention:

1. `merge-request` - when MR created/updated. Please always put in merge request title SemVer reserved word `major/minor/patch`. `patch` will be applyed automatically if nothing detected. Test build made by `gitlab-runner` to ensure image is correectly built. Nothing pushed to registry.
2. `master push` - after MR merged to master. Now version bump happened using mr title reserved word if exist. And new tag pushed to repo. Package.json also modified.
3. `new version tag` - when new version tag automatically appear `build-and-push` job started by `gitlab-runner`. Image built nad pushed to registry. Now it can be manually deployed to qa-env. After - to stage and to prod accordingly.

# Troubleshooting for Windows OS

### Docker
To make Docker work properly it must be in "Linux containters" mode.

To check is correct mode enabled: right click on docker icon, if there is "Switch to Windows containers..." option is present - you already in Linux mode.

If you have an option "Switch to Linux containers..." - you need to switch to it. If switching return an error - try to check "Virtualization" option in "Performance" tab of Task Manager (Ctrl + Alt + Delete => Task Manager) - it must be Enabled. If this option is disabled - you may fix it via Ciklum ITD (ServiceNow), or you may do it in BIOS. After enabling - try to launch "Switch to Linux containers..." again.

### Pre-commit hooks
If you faced a lot of errors like "Expected linebreaks to be 'LF' but found 'CRLF' linebreak-style" - you need to change linebreak mode to LF. You may do this in settings of your IDE, or in by modifying git config file (core.autocrlf option need to be set to false value).

# Links
- [Delivery Framework](https://gitlab.ciklum.net/st/delivery-framework)


