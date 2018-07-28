#!/bin/bash
export DOCKER_COMPOSE=$(which docker-compose)
envsubst < jenkins.service.template > /etc/systemd/system/jenkins.service
