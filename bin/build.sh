#!/bin/bash -xe
cd "$(dirname "$0")/.."

source bin/env
docker build -t armory/debugging-tools:${DOCKER_TAG} .

# spit out a new kube-pod spec
cat << EOF > kube-pod.yml
# WARNING, this is rendered using templates/kube-pod.yml
# any changes here will not be reflected on the next build

EOF

cat templates/kube-pod.yml | sed 's@$DOCKER_TAG@'"$DOCKER_TAG"'@' >> kube-pod.yml
