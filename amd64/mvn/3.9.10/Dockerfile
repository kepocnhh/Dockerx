from docker.io/kepocnhh/gradle-amd64:8.10.2c

workdir /workdir

env MAVEN_VERSION='3.9.10'
env MAVEN_HOME="/opt/apache-maven-${MAVEN_VERSION}/bin"

run curl -L "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip" \
 -o /tmp/foo && unzip -d /opt/ /tmp/foo && rm /tmp/foo

env PATH="${PATH}:${MAVEN_HOME}"

run mvn --version
