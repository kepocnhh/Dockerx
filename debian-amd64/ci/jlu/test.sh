#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'
REPOSITORY="ci-jlu-${ARCH}"
TAG='0.4b'
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${TAG}"

docker build --no-cache --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then
 echo "Docker build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then
 echo 'Run error!'; exit 1; fi

REPOSITORY_OWNER='kepocnhh'
REPOSITORY_NAME='Useless.Java.Lib'

if test $? -ne 0; then
 echo 'Make dir error!'; exit 1; fi

SOURCE_COMMIT='87b6a7cd422cc0e5ea8735b1112b71785cd84f60'

for it in \
 'git init' \
 "git remote add origin https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git" \
 "git fetch origin ${SOURCE_COMMIT}" \
 "git checkout ${SOURCE_COMMIT}"; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Checkout error!'; exit 1; fi
done

for it in \
 'unstable/check.sh'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Gradle error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
