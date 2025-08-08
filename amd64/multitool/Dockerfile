from docker.io/kepocnhh/mvn-amd64:3.9.11c

workdir /workdir

env MULTITOOL_VERSION='0.5.0'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"
env mt="${MULTITOOL_HOME}"

run curl -L "https://github.com/StanleyProjects/Multitool/archive/refs/tags/${MULTITOOL_VERSION}.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env PATH="${PATH}:${MULTITOOL_HOME}"

run mkdir .mt
