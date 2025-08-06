#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'
REPOSITORY="multitool-${ARCH}"
MULTITOOL_VERSION='0.3.1'
TAG="${MULTITOOL_VERSION}c"
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${TAG}"

docker build --no-cache \
 -f "${ARCH}/multitool/Dockerfile" \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then echo "Build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -e REPOSITORY_OWNER='kepocnhh' \
 -e REPOSITORY_NAME='Useless.Java.Lib' \
 -e SOURCE_COMMIT='42de2210d34ffe63de8b1020dc939feaa7175e26' \
 -e TARGET_BRANCH='master' \
 -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then echo 'Run error!'; exit 1; fi

for it in \
 'git init' \
 'git remote add origin https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git' \
 'git fetch origin ${TARGET_BRANCH}' \
 'git fetch origin ${SOURCE_COMMIT}' \
 'git switch ${TARGET_BRANCH}' \
 'git config user.name "foo"' \
 'git config user.email "foo@bar.org"'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Checkout error!'; exit 1; fi
done

for it in \
 '$mt/vcs/merge.sh' \
 '$mt/java/lib/unstable/assemble.sh' \
 '$mt/vcs/commit.sh "msg" "tag"' \
 '$mt/java/lib/unstable/check.sh'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"
