#!/usr/local/bin/bash

for it in REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT VCS_PAT; do
 if test -z "${!it}"; then echo "Argument \"${it}\" is empty!"; exit 1; fi; done

GITHUB_USER="$(curl -f 'https://api.github.com/user' -H "Authorization: token $VCS_PAT")"
if test $? -ne 0; then echo 'Get user error!'; exit 1
elif test -z "$GITHUB_USER"; then echo 'User is empty!'; exit 1; fi

USER_NAME="$(echo "$GITHUB_USER" | yq -erM .name)" || exit 1
USER_ID="$(echo "$GITHUB_USER" | yq -erM .id)" || exit 1
USER_LOGIN="$(echo "$GITHUB_USER" | yq -erM .login)" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

VARIANT='unstable'
TARGET_BRANCH="${VARIANT}"

git init \
 && git remote add origin "https://${VCS_PAT}@github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git" \
 && git fetch origin "${TARGET_BRANCH}" \
 && git fetch origin "${SOURCE_COMMIT}" \
 && git switch "${TARGET_BRANCH}"

if test $? -ne 0; then echo 'Checkout error!'; exit 1; fi

git config user.name "${USER_NAME}" \
 && git config user.email "${USER_EMAIL}"
if test $? -ne 0; then echo "Config error!"; exit 1; fi

git merge --no-ff --no-commit "${SOURCE_COMMIT}"
 if test $? -ne 0; then echo 'Merge error!'; exit 1; fi

${VARIANT}/metadata/assemble.sh \
 && ${VARIANT}/vcs/commit.sh \
 && ${VARIANT}/check.sh
if test $? -ne 0; then echo 'Pipeline error!'; exit 1; fi

git push && git push --tag
 if test $? -ne 0; then echo 'Push error!'; exit 1; fi
