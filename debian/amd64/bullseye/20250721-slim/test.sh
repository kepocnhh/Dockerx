#!/usr/local/bin/bash

PLATFORM='linux/amd64'
TYPE='test'
NAMESPACE='kepocnhh'
ARCH='amd64'
IMAGE_NAME="${NAMESPACE}/debian-${ARCH}"
IMAGE_VERSION='5a'
TAG="${IMAGE_NAME}:${IMAGE_VERSION}"

#docker build --no-cache \
docker build \
 -f Dockerfile \
 --platform="${PLATFORM}" \
 -t "${TAG}" .

if test $? -ne 0; then
 echo "Docker build error!"; exit 21; fi

CONTAINER_NAME="container.${TYPE}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run -id --name "${CONTAINER_NAME}" "${TAG}"

if test $? -ne 0; then
 echo 'Run error!'; exit 1; fi

docker exec "${CONTAINER_NAME}" \
 curl --version && \
 openssl version && \
 perl --version && \
 git --version && \
 gpg --version && \
 zip --version && \
 yq --version && \
 /usr/local/bin/bash --version

if test $? -ne 0; then
 echo 'Exec error!'; exit 1; fi

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
