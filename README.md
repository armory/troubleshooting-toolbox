# debugging-tools

This repo contains the Dockerfile for [armory/debugging-tools](https://cloud.docker.com/u/armory/repository/docker/armory/debugging-tools).

The `kube-pod.yml` manifest is available to put into your kubernetes cluster.

## Building and pushing
```bash
./bin/build.sh  # will build a new container and kub manifest
./bin/push.sh   # will push the tagged container
```
