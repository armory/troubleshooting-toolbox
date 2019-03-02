#!/bin/bash -xe
cd "$(dirname "$0")/.."

source bin/env
docker build -t armory/debugging-tools:${DOCKER_TAG} .

# spit out a new deployment spec
cat << EOF > deployment.yml
# WARNING, this is rendered using templates/deployment.yml
# any changes here will not be reflected on the next build

EOF

cat templates/deployment.yml | sed 's@$DOCKER_TAG@'"$DOCKER_TAG"'@' >> deployment.yml
