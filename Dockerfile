FROM alpine:3.8
MAINTAINER Armory <eng@amrory.io>

ENV KUBECTL_RELEASE=1.11.5
ENV HEPTIO_BINARY_RELEASE_DATE=2018-12-06
ENV JQ_VERSION=1.6_rc1-r1
ENV AWS_CLI_VERSION=1.16.76

RUN apk update && apk add --no-cache \
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
  vim \
  && pip install --upgrade awscli==$AWS_CLI_VERSION && \
  rm -rf /var/cache/apk/*


# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl


# install aws-iam-authenticator for kubectl
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_RELEASE}/${HEPTIO_BINARY_RELEASE_DATE}/bin/linux/amd64/aws-iam-authenticator && \
  chmod +x ./aws-iam-authenticator && \
  mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

ENV PATH "$PATH:/usr/local/bin/aws-iam-authenticator"


# install vault
RUN curl -O https://releases.hashicorp.com/vault/1.0.3/vault_1.0.3_linux_amd64.zip \
  && unzip vault* \
  && mv vault /usr/bin/ \
  && rm -rf vault*


# copy over a default (not working) ~/.aws/config for easier assume role tests
COPY templates/aws-config /root/.aws/config

# setup some bash completion
COPY .bashrc /root/.bashrc
