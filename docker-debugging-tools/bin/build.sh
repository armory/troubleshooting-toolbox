#!/bin/bash -xe
cd "$(dirname "$0")/.."

source bin/env
docker buildx build --push --platform linux/arm64,linux/amd64 -t "${DOCKER_IMAGE}" .
docker buildx build --push --platform linux/arm64,linux/amd64 -t "${DOCKER_SSH_IMAGE}" -f Dockerfile-sshd .
