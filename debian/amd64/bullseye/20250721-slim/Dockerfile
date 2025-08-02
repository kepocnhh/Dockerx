from amd64/debian:bullseye-20250721-slim

run echo 'deb http://deb.debian.org/debian bullseye main' \
 > /etc/apt/sources.list

run apt-get update \
 && apt-get upgrade -y \
 && apt autoremove

run apt-get install --no-install-recommends -y curl unzip \
 && curl --version

run apt-get install --no-install-recommends -y openssl ca-certificates \
 && openssl version

run update-ca-certificates -f

run apt-get install --no-install-recommends -y git \
 && git --version

run apt-get install --no-install-recommends -y jq \
 && jq --version

run apt-get install --no-install-recommends -y gpg gpg-agent \
 && gpg --version

run apt-get install --no-install-recommends -y zip \
 && zip --version

run apt-get install --no-install-recommends -y xz-utils

env YQ_VERSION='4.47.1'
env PATH="${PATH}:/opt/yq-${YQ_VERSION}"
run mkdir /opt/yq-${YQ_VERSION} && \
 curl -L https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_arm64 \
  -o /opt/yq-${YQ_VERSION}/yq \
 && chmod +x /opt/yq-${YQ_VERSION}/yq \
 && yq --version

run ln -s /bin/bash /usr/local/bin/bash \
 && /usr/local/bin/bash --version
