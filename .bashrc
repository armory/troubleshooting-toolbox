#!/bin/bash

source /etc/profile.d/bash_completion.sh

# shorten kubectl
function kub () {
  kubectl $@
}
export -f kub

function k () {
  kubectl $@
}
export -f k

source <(kubectl completion bash)

# add completion
complete -o default -F __start_kubectl k
complete -o default -F __start_kubectl kub

complete -C $(which vault) vault
