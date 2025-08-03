#!/usr/local/bin/bash

ARCH='arm64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'
REPOSITORY="debian-${ARCH}"
TAG='8a'
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${TAG}"

docker build --no-cache -f Dockerfile \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then
 echo "Docker build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then
 echo 'Run error!'; exit 1; fi

for it in \
 'curl --version' \
 'openssl version' \
 'gpg --version' \
 'zip --version' \
 'yq --version' \
 'git --version' \
 'git clone https://github.com/kepocnhh/Dockerx.git' \
 'git -C ./Dockerx status' \
 'cat ./Dockerx/README.md' \
 '/usr/local/bin/bash --version'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "$it"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
