# debugging-tools

This repo contains the Dockerfile for [armory/debugging-tools](https://hub.docker.com/r/armory/debugging-tools).

The [`deployment.yml`](https://github.com/armory/docker-debugging-tools/blob/master/docker-debugging-tools/deployment.yml) manifest is available to put into your kubernetes cluster.
```bash
MY_CONTEXT=
MY_NAMESPACE=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE apply -f  https://raw.githubusercontent.com/armory/docker-debugging-tools/master/docker-debugging-tools/deployment.yml

kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE exec -it deploy/debugging-tools -- bash


# and when you're done, delete the deployment
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE delete deployment debugging-tools
```

## SSH Server for reverse tunneling

This repo also contains the Dockerfile for a ssh server, useful for making reverse tunnels to achieve a kind of "kubectl reverse-port-forward" behavior, and be able to expose services running in your local machine to the rest of the cluster. This server requires that you mount a `id_rsa.pub` key into `/root/.ssh/authorized_keys` to be able to log in.
```bash
MY_CONTEXT=
MY_NAMESPACE=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE create cm ssh-key --from-file=authorized_keys=${HOME}/.ssh/id_rsa.pub --dry-run -o yaml | kubectl apply -f -
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE apply -f https://raw.githubusercontent.com/armory/docker-debugging-tools/master/docker-debugging-tools/deployment-sshd.yml
```
To run the reverse proxy first forward ssh port:
```bash
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE port-forward deployment/debugging-tools-sshd 2222:22 &
```
Then in separate terminals run ssh client for as many port as needed:
```bash
PORT_TO_FORWARD_1=
ssh -p 2222 -g -R $PORT_TO_FORWARD_1:localhost:$PORT_TO_FORWARD_1 root@localhost

# --- Separate terminal ---
PORT_TO_FORWARD_2=
ssh -p 2222 -g -R $PORT_TO_FORWARD_2:localhost:$PORT_TO_FORWARD_2 root@localhost
```


## Using this as Daemonset
Sometimes it's useful to debug some issues with a node, especially in networking situations.
You can also deploy `debugging-tools` out as a daemonset.

> Note: you can also uncomment `.spec.template.spec.nodeName` to pin the container to a certain node. See https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ for more details.
```bash
MY_CONTEXT=
MY_NAMESPACE=
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE apply -f  https://raw.githubusercontent.com/armory/docker-debugging-tools/master/docker-debugging-tools/daemonset.yml

kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE get pods -o wide

# get a pod from above that's on the right node
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE exec -it $POD_NAME bash


# and when you're done, delete the daemonset
kubectl --context=$MY_CONTEXT -n $MY_NAMESPACE delete daemonset debugging-tools
```



## Building, committing, and pushing
```bash
git commit -m "fix(component): your commit message here"
./bin/build.sh  # will build a new container and kub manifest
./bin/push.sh   # will push the docker container and new manifest
git commit -m "chore(kube-manifest): update new docker image" deployment.yml
git push
```
