from docker.io/kepocnhh/jdk-amd64:17.0.11

env GRADLE_VERSION='8.10.2'
run curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/foo \
 && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env GRADLE_HOME="/opt/gradle-${GRADLE_VERSION}"
env PATH="${PATH}:${GRADLE_HOME}/bin"

run gradle --version
