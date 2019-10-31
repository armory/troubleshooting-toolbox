FROM alpine:3.10
MAINTAINER Armory <eng@armory.io>

ENV KUBECTL_RELEASE=1.13.7
ENV AWS_IAM_AUTHENTICATOR_VERSION=2019-06-11
ENV JQ_VERSION=1.6-r0
ENV AWS_CLI_VERSION=1.16.208
ENV VAULT_VERSION=1.2.0


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
  py-pip \
  python \
  redis \
  vim \
  netcat-openbsd \
  && pip install --upgrade awscli==$AWS_CLI_VERSION \
  && rm -rf /var/cache/apk/*


# install kubectl, latest version can be found here: https://storage.googleapis.com/kubernetes-release/release/stable.txt
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl \
  && ln -sv /usr/local/bin/kubectl /usr/local/bin/k \
  && ln -sv /usr/local/bin/kubectl /usr/local/bin/kub


# install aws-iam-authenticator for kubectl
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_RELEASE}/${AWS_IAM_AUTHENTICATOR_VERSION}/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x ./aws-iam-authenticator \
  && mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

ENV PATH "$PATH:/usr/local/bin/aws-iam-authenticator"


# install vault, latest version can be found here: https://www.vaultproject.io/downloads.html
RUN curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
  && unzip vault* \
  && mv vault /usr/bin/ \
  && rm -rf vault*


# copy over a default (not working) ~/.aws/config for easier assume role tests
COPY templates/aws-config /root/.aws/config

# setup some bash completion
COPY .bashrc /root/.bashrc

ENTRYPOINT bash
