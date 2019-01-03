#!/bin/bash -xe
cd "$(dirname "$0")/.."


source bin/env

docker push armory/debugging-tools:${DOCKER_TAG}
