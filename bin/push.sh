#!/bin/bash -xe
cd "$(dirname "$0")/.."


source bin/env


docker push "${DOCKER_IMAGE}"
