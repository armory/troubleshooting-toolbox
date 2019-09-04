# debugging-tools

This repo contains the Dockerfile for [armory/debugging-tools](https://hub.docker.com/r/armory/debugging-tools).

The [`deployment.yml`](https://github.com/armory/docker-debugging-tools/blob/master/deployment.yml) manifest is available to put into your kubernetes cluster.
```bash
MY_CONTEXT=
MY_NAMESPACE=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE apply -f  https://raw.githubusercontent.com/armory/docker-debugging-tools/master/deployment.yml

POD_NAME=$(kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE get pod -l app=debugging-tools -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' --sort-by=".status.startTime" | tail -n 1)
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE exec -it $POD_NAME bash


# and when you're done, delete the deployment
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE delete deployment debugging-tools
```

## Building, committing, and pushing
```bash
git commit -m "fix(component): your commit message here"
./bin/build.sh  # will build a new container and kub manifest
./bin/push.sh   # will push the docker container and new manifest
git commit -m "chore(kube-manifest): update new docker image" deployment.yml
git push
```
