#!/usr/local/bin/bash

ARCH='amd64'
PLATFORM="linux/${ARCH}"
HOST='docker.io'
NAMESPACE='kepocnhh'

ISSUER='multitool'
ISSUER_VERSION='0.6.2'
REPOSITORY="${ISSUER}-${ISSUER_VERSION}-${ARCH}"
IMAGE_VERSION=6
IMAGE_FLAVOR='d'
IMAGE_TAG="${IMAGE_VERSION}${IMAGE_FLAVOR}"
IMAGE_NAME="${HOST}/${NAMESPACE}/${REPOSITORY}:${IMAGE_TAG}"

docker build --no-cache \
 -f "${ARCH}/${ISSUER}/Dockerfile" \
 --platform="${PLATFORM}" -t "${IMAGE_NAME}" .

if test $? -ne 0; then echo "Build error!"; exit 21; fi

CONTAINER_NAME="container.${REPOSITORY}"

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

docker run --platform="${PLATFORM}" \
 -e REPOSITORY_OWNER='kepocnhh' \
 -e REPOSITORY_NAME='Useless.Java.Lib' \
 -e SOURCE_COMMIT='5dd636be4b8e236f0ba5df28bcd934b923b718d3' \
 -e TARGET_BRANCH='master' \
 -e GPG_PASSWORD='qwer1234' \
 -e GPG_KEY_ID='2AC43613F5502EB3C490D2C62CFF9BD0725E548B' \
 -id --name "${CONTAINER_NAME}" "${IMAGE_NAME}"

if test $? -ne 0; then echo 'Run error!'; exit 1; fi

docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c \
 "test \"\$(cat /etc/flavor)\" == \"${IMAGE_FLAVOR}\""
if test $? -ne 0; then echo 'Flavor error!'; exit 1; fi

docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c \
 "test \"\${MULTITOOL_VERSION}\" == \"${ISSUER_VERSION}\""
if test $? -ne 0; then echo 'Version error!'; exit 1; fi

docker cp "${ARCH}/${ISSUER}/key.pgp" "${CONTAINER_NAME}:/tmp/key.pgp"
if test $? -ne 0; then echo 'Copy error!'; exit 1; fi

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
 'java --version' \
 'gradle --version' \
 'mvn --version' \
 'gpg --version' \
 'gpg --batch --import /tmp/key.pgp' \
 'gpg --list-keys && gpg --list-secret-keys --keyid-format=long' \
 'git config gpg.program "/usr/local/bin/gpgloopback.sh"' \
 'git config user.signingkey "${GPG_KEY_ID}"' \
 '$mt/vcs/merge.sh' \
 '$mt/java/lib/unstable/assemble.sh' \
 '$mt/vcs/commit.sh "msg" "tag"' \
 '$mt/java/lib/unstable/check.sh' \
 'echo foobarbaz > /tmp/foo.txt' \
 '$mt/secrets/sha256.sh /tmp/foo.txt' \
 'cat /tmp/foo.txt.sha256' \
 'cat $mt/README.md'; do
 docker exec "${CONTAINER_NAME}" /usr/local/bin/bash -c "${it}"
 if test $? -ne 0; then echo 'Exec error!'; exit 1; fi
done

docker stop "${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

echo "Push to Docker repository?"
read -r YES_OR_NOT

if test "${YES_OR_NOT}" != 'yes'; then exit 0; fi

docker push "${IMAGE_NAME}"
if test $? -ne 0; then echo 'Docker push error!'; exit 1; fi

echo "Docker image ${IMAGE_NAME} pushed."

echo 'Push to GIT repository?'
read -r YES_OR_NOT
if test "${YES_OR_NOT}" != 'yes'; then exit 0; fi

git add . \
 && git commit -m "${REPOSITORY}:${IMAGE_TAG}" \
 && git push

if test $? -ne 0; then echo 'Commit push error!'; exit 1; fi

echo "Push tag \"${REPOSITORY}/${IMAGE_TAG}\" to GIT repository?"
read -r YES_OR_NOT
if test "${YES_OR_NOT}" != 'yes'; then exit 0; fi

git tag "${REPOSITORY}/${IMAGE_TAG}" \
 && git push \
 && git push --tag

if test $? -ne 0; then echo "Tag \"${REPOSITORY}/${IMAGE_TAG}\" push error!"; exit 1; fi

git log --graph --all -2
