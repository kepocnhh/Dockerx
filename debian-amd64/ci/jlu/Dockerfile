from docker.io/kepocnhh/gradle-amd64:8.10.2b

workdir /ci/java/lib/

env MULTITOOL_VERSION='0.1.0'
env MULTITOOL_HOME="/opt/Multitool-${MULTITOOL_VERSION}"

run curl -L "https://github.com/StanleyProjects/Multitool/archive/refs/tags/${MULTITOOL_VERSION}.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

run cp -r "${MULTITOOL_HOME}/checks" .
run cp -r "${MULTITOOL_HOME}/vcs" .
run cp -r "${MULTITOOL_HOME}/java/lib/unstable" .
