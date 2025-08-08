#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'
REPOSITORY="mvn-${ARCH}"
MVN_VERSION='3.9.11'
TAG="${MVN_VERSION}c"
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${TAG}"

docker build --no-cache \
 -f "${ARCH}/mvn/${MVN_VERSION}/Dockerfile" \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then echo "Build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then echo 'Run error!'; exit 1; fi

for it in \
 'yq ~/.m2/settings.xml' \
 'mvn --version' \
 '${MAVEN_HOME}/bin/mvn --version' \
 'cat ${MAVEN_HOME}/README.txt'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
