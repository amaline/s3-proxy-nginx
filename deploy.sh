#!/bin/bash
echo "Create tag if it has not already been created"
(git rev-parse ${GITHUB_RELEASE} || ( git tag ${GITHUB_RELEASE} && git push https://${GITHUB_TOKEN}:@${PROJECT_REPOSITORY} --tags))
echo "Creating release..."
echo {"tag_name": "${GITHUB_RELEASE}","target_commitish": "master","name": "release ${GITHUB_RELEASE} for custom nginx build","body": "release ${GITHUB_RELEASE} for custom nginx build for cloud foundry s3 proxy","draft": false,"prerelease": true} > json.json
curl -# -XPOST -H 'Content-Type:application/json' -H 'Accept:application/json' --data-binary @json.json https://api.github.com/repos/${GITHUB_PROJECT}/releases?access_token=${GITHUB_TOKEN} -o response.json
del json.json
cat response.json
curl -# -XPOST -H "Authorization: ${GITHUB_TOKEN}" -H "Content-Type: application/octet-stream" --data-binary @${CIRCLE_ARTIFACTS}/${ASSET_NAME} https://uploads.github.com/repos/${GITHUB_PROJECT}/releases/`git rev-parse ${GITHUB_RELEASE}`/assets?name=${ASSET_NAME}
