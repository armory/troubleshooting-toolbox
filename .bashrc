#!/bin/bash

source /etc/profile.d/bash_completion.sh

source <(kubectl completion bash)

# add completion for shorten aliases
complete -o default -F __start_kubectl k
complete -o default -F __start_kubectl kub

complete -C $(which vault) vault

complete -C aws_completer aws
