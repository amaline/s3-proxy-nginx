#!/bin/bash
(git rev-parse ${GITHUB_RELEASE} || ( git tag ${GITHUB_RELEASE} && git push https://${GITHUB_TOKEN}:@${PROJECT_REPOSITORY} --tags))
curl -# -XPOST -H "Authorization: ${GITHUB_TOKEN}" -H "Content-Type: application/octet-stream" --data-binary @${CIRCLE_ARTIFACTS}/${ASSET_NAME} https://uploads.github.com/repos/${GITHUB_PROJECT}/releases/`git rev-parse ${GITHUB_RELEASE}`/assets?name=${ASSET_NAME}
