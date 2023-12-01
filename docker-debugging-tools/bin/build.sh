#!/bin/bash -xe
cd "$(dirname "$0")/.."

source bin/env
docker buildx build --push --platform linux/arm64,linux/amd64 -t "${DOCKER_IMAGE}" -t "${DOCKER_IMAGE_LATEST}" .
docker buildx build --push --platform linux/arm64,linux/amd64 -t "${DOCKER_SSH_IMAGE}" -t "${DOCKER_SSH_IMAGE_LATEST}" -f Dockerfile-sshd .
