#!/usr/bin/env bash
BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW=$(tput setaf 3)
NC='\033[0m' # No Color

function chmodFile () {
    if [ ! -f ${1} ]; then
        printf "${YELLOW}${1} not found${NC}\n";
        return
    fi

    printf "chmod +x ${1}";

    if chmod +x ${1}; then
        printf " ${GREEN}[OK]${NC}\n";
    else
        printf " ${RED}[Error]${NC}\n";
    fi
}

printf "${LBLUE}Gonna make all this scripts executable ...${NC}\n";

currDir="$(pwd)"
printf "Base dir: $currDir\n";

printf "${GREEN}./devops/ci/scripts/${NC}\n";
chmodFile ./devops/ci/scripts/bump-version.job.sh
chmodFile ./devops/ci/scripts/bump-version.sh
chmodFile ./devops/ci/scripts/check-free-space.sh
chmodFile ./devops/ci/scripts/deploy.dev.sh
chmodFile ./devops/ci/scripts/deploy.prod.sh
chmodFile ./devops/ci/scripts/deploy.qa.sh
chmodFile ./devops/ci/scripts/deploy.stage.sh
chmodFile ./devops/ci/scripts/get-latest-version.sh
chmodFile ./devops/ci/scripts/login-to-git.sh
chmodFile ./devops/ci/scripts/pipeline-dependency.sh
chmodFile ./devops/ci/scripts/post-jira-comment.sh
chmodFile ./devops/ci/scripts/semver.sh

printf "${GREEN}./devops/docker/scripts/${NC}\n";
chmodFile ./devops/docker/scripts/cleanup.sh
chmodFile ./devops/docker/scripts/connect-bash.sh
chmodFile ./devops/docker/scripts/login-to-registry.sh
chmodFile ./devops/docker/scripts/pull-image.sh
chmodFile ./devops/docker/scripts/push-image.sh
chmodFile ./devops/docker/scripts/push-latest-image.sh
chmodFile ./devops/docker/scripts/rm-all.sh
chmodFile ./devops/docker/scripts/rm-all-volumes.sh
chmodFile ./devops/docker/scripts/run-bash.sh
chmodFile ./devops/docker/scripts/run-bash.loc.sh
chmodFile ./devops/docker/scripts/soft-cleanup.sh
chmodFile ./devops/docker/scripts/stop-all.sh
chmodFile ./devops/docker/scripts/cleanup-dungling.sh
chmodFile ./devops/docker/launch.sh

printf "${GREEN}./devops/local/scripts/${NC}\n";
chmodFile ./devops/local/scripts/check-env-vars.sh
chmodFile ./devops/local/scripts/load-env.sh

printf "${GREEN}./devops/scripts/${NC}\n";
chmodFile ./devops/scripts/build.sh
chmodFile ./devops/scripts/up.loc.sh
chmodFile ./devops/scripts/up.loc.isolated.sh
chmodFile ./devops/scripts/up.prod.loc.sh
chmodFile ./devops/scripts/install-app.sh
chmodFile ./devops/scripts/install-app-svc.sh

printf "${LBLUE}Done${NC}\n";
