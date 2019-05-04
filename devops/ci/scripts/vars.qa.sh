#!/usr/bin/env bash
vars="export                                    DOCKER_REGISTRY_USER=$DOCKER_REGISTRY_USER      DOCKER_REGISTRY_PWD=$DOCKER_REGISTRY_PWD    DOCKER_REGISTRY_HOST=$DOCKER_REGISTRY_HOST                      HOSTNAME_QA=$HOSTNAME_QA                    APP_GROUP_CONFIG_QA='$APP_GROUP_CONFIG_QA'          LAND_APP_SVC_PORT=$LAND_APP_SVC_PORT    LAND_APP_SVC_DEBUG_PORT=$LAND_APP_SVC_DEBUG_PORT    LAND_APP_SVC_HOST=$LAND_APP_SVC_HOST                LAND_SVC_HOST=$LAND_SVC_HOST          PORTAL_APP_SVC_PORT=$PORTAL_APP_SVC_PORT PORTAL_APP_SVC_DEBUG_PORT=$PORTAL_APP_SVC_DEBUG_PORT PORTAL_APP_SVC_HOST=$PORTAL_APP_SVC_HOST      SHARED_APP_SVC_PORT=$SHARED_APP_SVC_PORT SHARED_APP_SVC_DEBUG_PORT=$SHARED_APP_SVC_DEBUG_PORT SHARED_APP_SVC_HOST=$SHARED_APP_SVC_HOST                  SKILLS_APP_SVC_PORT=$SKILLS_APP_SVC_PORT SKILLS_APP_SVC_DEBUG_PORT=$SKILLS_APP_SVC_DEBUG_PORT SKILLS_APP_SVC_HOST=$SKILLS_APP_SVC_HOST      SKILLS_SVC_HOST=$SKILLS_SVC_HOST SKILLS_SVC_POSTGRES_USER=$SKILLS_SVC_POSTGRES_USER SKILLS_SVC_POSTGRES_PASSWORD=$SKILLS_SVC_POSTGRES_PASSWORD SKILLS_SVC_POSTGRES_PORT=$SKILLS_SVC_POSTGRES_PORT SKILLS_SVC_POSTGRES_HOST=$SKILLS_SVC_POSTGRES_HOST SKILLS_SVC_POSTGRES_DB=$SKILLS_SVC_POSTGRES_DB RECRUITMENT_SVC_POSTGRES_USER=$RECRUITMENT_SVC_POSTGRES_USER RECRUITMENT_SVC_POSTGRES_PASSWORD=$RECRUITMENT_SVC_POSTGRES_PASSWORD RECRUITMENT_SVC_POSTGRES_PORT=$RECRUITMENT_SVC_POSTGRES_PORT RECRUITMENT_SVC_POSTGRES_HOST=$RECRUITMENT_SVC_POSTGRES_HOST RECRUITMENT_SVC_POSTGRES_DB=$RECRUITMENT_SVC_POSTGRES_DB SFIA_SVC_POSTGRES_USER=$SFIA_SVC_POSTGRES_USER SFIA_SVC_POSTGRES_PASSWORD=$SFIA_SVC_POSTGRES_PASSWORD SFIA_SVC_POSTGRES_PORT=$SFIA_SVC_POSTGRES_PORT SFIA_SVC_POSTGRES_HOST=$SFIA_SVC_POSTGRES_HOST SFIA_SVC_POSTGRES_DB=$SFIA_SVC_POSTGRES_DB AUTH_SVC_POSTGRES_USER=$AUTH_SVC_POSTGRES_USER AUTH_SVC_POSTGRES_PASSWORD=$AUTH_SVC_POSTGRES_PASSWORD AUTH_SVC_POSTGRES_PORT=$AUTH_SVC_POSTGRES_PORT AUTH_SVC_POSTGRES_HOST=$AUTH_SVC_POSTGRES_HOST AUTH_SVC_POSTGRES_DB=$AUTH_SVC_POSTGRES_DB                    AUTH_SVC_IMS_HOST=$AUTH_SVC_IMS_HOST                 IM_SVC_POSTGRES_USER=$IM_SVC_POSTGRES_USER IM_SVC_POSTGRES_PASSWORD=$IM_SVC_POSTGRES_PASSWORD IM_SVC_POSTGRES_PORT=$IM_SVC_POSTGRES_PORT    IM_SVC_POSTGRES_HOST=$IM_SVC_POSTGRES_HOST         IM_SVC_POSTGRES_DB=$IM_SVC_POSTGRES_DB
;"

echo $vars