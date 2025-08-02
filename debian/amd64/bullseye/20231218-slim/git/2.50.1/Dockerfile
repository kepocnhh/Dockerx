from amd64/debian:bullseye-20231218-slim

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

run apt-get install --no-install-recommends -y make \
 && make --version

run apt-get install --no-install-recommends -y autoconf \
 && autoconf --version

run apt-get install --no-install-recommends -y gcc libc6-dev libz-dev \
 && gcc --version

run apt-get install --no-install-recommends -y tcl \
 && tclsh --version

run apt-get install --no-install-recommends -y gettext \
 && msgfmt --version

env GIT_VERSION='2.50.1'
env PATH="${PATH}:/opt/git-${GIT_VERSION}"
run curl "https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz" \
 -o tmpfile && tar xf tmpfile -C /opt/ && rm tmpfile
run cd /opt/git-${GIT_VERSION} && make configure && ./configure && make install
run git --version

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
