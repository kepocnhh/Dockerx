#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
TYPE='test'
NAMESPACE='kepocnhh'
IMAGE_NAME="${NAMESPACE}/debian-${ARCH}"
IMAGE_VERSION='6a'
TAG="${IMAGE_NAME}:${IMAGE_VERSION}"

docker build --no-cache -f Dockerfile \
 --platform="${PLATFORM}" -t "${TAG}" .

if test $? -ne 0; then
 echo "Docker build error!"; exit 21; fi

CONTAINER_NAME="container.${TYPE}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -id --name "${CONTAINER_NAME}" "${TAG}"

if test $? -ne 0; then
 echo 'Run error!'; exit 1; fi

for it in \
 'curl --version' \
 'openssl version' \
 'perl --version' \
 'git --version' \
 'gpg --version' \
 'zip --version' \
 'yq --version' \
 '/usr/local/bin/bash --version' \
 'git clone https://github.com/kepocnhh/Dockerx.git' \
 'git -C ./Dockerx status' \
 'cat ./Dockerx/README.md'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "$it"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
