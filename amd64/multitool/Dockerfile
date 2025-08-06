from docker.io/kepocnhh/gradle-amd64:8.10.2b

workdir /workdir

env MULTITOOL_VERSION='0.3.1'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"
env mt="${MULTITOOL_HOME}"

run curl -L "https://github.com/StanleyProjects/Multitool/archive/refs/tags/${MULTITOOL_VERSION}.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env PATH="${PATH}:${MULTITOOL_HOME}"

run mkdir .mt
