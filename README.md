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

## SSH Server for reverse tunneling

This repo also contains the Dockerfile for a ssh server, useful for making reverse tunnels to achieve a kind of "kubectl reverse-port-forward" behavior, and be able to expose services running in your local machine to the rest of the cluster. This server requires that you mount a `id_rsa.pub` key into `/root/.ssh/authorized_keys` to be able to log in.
```bash
MY_CONTEXT=
MY_NAMESPACE=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE create cm ssh-key --from-file=authorized_keys=${HOME}/.ssh/id_rsa.pub --dry-run -o yaml | kubectl apply -f -
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE apply -f https://raw.githubusercontent.com/armory/docker-debugging-tools/master/deployment-sshd.yml
```
To run the reverse proxy:
```
PORT_TO_FORWARD=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE port-forward deployment/sshd 2222:22 &
sleep 5
ssh -p 2222 -g -R $PORT_TO_FORWARD:localhost:$PORT_TO_FORWARD root@localhost
```

## Building, committing, and pushing
```bash
git commit -m "fix(component): your commit message here"
./bin/build.sh  # will build a new container and kub manifest
./bin/push.sh   # will push the docker container and new manifest
git commit -m "chore(kube-manifest): update new docker image" deployment.yml
git push
```
