#!/bin/bash -xe
cd "$(dirname "$0")/.."

source bin/env
docker build -t "${DOCKER_IMAGE}" .
docker build -t "${DOCKER_SSH_IMAGE}" .
