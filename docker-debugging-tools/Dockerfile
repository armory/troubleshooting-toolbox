FROM --platform=$TARGETPLATFORM alpine:3
MAINTAINER Armory <eng@armory.io>

ARG TARGETARCH

ENV KUBECTL_RELEASE=1.27.3
ENV AWS_IAM_AUTHENTICATOR_VERSION=0.6.2
ENV JQ_VERSION=1.6-r2
ENV AWS_CLI_VERSION=1.27.87
ENV VAULT_VERSION=1.13.0

# apk packages
RUN apk update && apk add --no-cache \
  bind-tools \
  bash \
  bash-completion \
  curl \
  git \
  groff \
  jq=$JQ_VERSION \
  less \
  mailcap \
  mysql-client \
  py-pip \
  python3 \
  redis \
  vim \
  && pip install  --no-build-isolation --upgrade awscli==$AWS_CLI_VERSION \
  && rm -rf /var/cache/apk/*

# install kubectl, latest version can be found here: https://storage.googleapis.com/kubernetes-release/release/stable.txt
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/${TARGETARCH}/kubectl \
  && chmod +x kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && ln -sv /usr/local/bin/kubectl /usr/local/bin/k \
  && ln -sv /usr/local/bin/kubectl /usr/local/bin/kub

# install aws-iam-authenticator, latest version can be found here: https://github.com/kubernetes-sigs/aws-iam-authenticator/releases
# note: for EKS you can also use `aws eks get-token` now, see https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
RUN curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_${TARGETARCH} \
  && chmod +x ./aws-iam-authenticator \
  && mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

# install vault, latest version can be found here: https://www.vaultproject.io/downloads.html
RUN curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip \
  && unzip vault* \
  && mv vault /usr/bin/ \
  && rm -rf vault*

# copy over a default (not working) ~/.aws/config for easier assume role tests
COPY templates/aws-config /root/.aws/config

# setup some bash completion
COPY .bashrc /root/.bashrc

ENTRYPOINT tail -f /dev/null
