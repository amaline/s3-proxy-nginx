#!/bin/bash
echo "GITHUB_PROJECT    = $GITHUB_PROJECT"
echo "GITHUB_RELEASE    = $GITHUB_RELEASE"
echo "PROJECT_REPOSITORY= $PROJECT_REPOSITORY"
echo "CIRCLE_ARTIFACTS  = $CIRCLE_ARTIFACTS"
echo "ASSET_NAME        = $ASSET_NAME"

echo "Exiting on any error"
set -e

echo "Create tag ${GITHUB_RELEASE}"
git tag ${GITHUB_RELEASE}

echo "Push tag to github repository ${GITHUB_PROJECT}"
git push https://${GITHUB_TOKEN}@${PROJECT_REPOSITORY} --tags

#echo "Create tag if it has not already been created"
#(git rev-parse ${GITHUB_RELEASE} || ( git tag ${GITHUB_RELEASE} && git push https://${GITHUB_TOKEN}@${PROJECT_REPOSITORY} --tags))

echo "Creating release..."

echo -e "{\n\"tag_name\": \"${GITHUB_RELEASE}\",\n\"target_commitish\": \"master\",\n\"name\": \"release ${GITHUB_RELEASE} for custom nginx build\",\n\"body\": \"release ${GITHUB_RELEASE} for custom nginx build for cloud foundry s3 proxy\",\n\"draft\": false,\n\"prerelease\": false\n}" > json.json
curl -# -XPOST -H 'Content-Type:application/json' -H 'Accept:application/json' --data-binary @json.json https://api.github.com/repos/${GITHUB_PROJECT}/releases?access_token=${GITHUB_TOKEN} -o response.json
rm json.json
RELEASE_ID=`cat response.json | jq '.id'`

echo "Upload ${CIRCLE_ARTIFACTS}/${ASSET_NAME} to github release ${GITHUB_RELEASE} ID=${RELEASE_ID}"
curl -# -XPOST -H "Authorization: bearer ${GITHUB_TOKEN}" -H "Content-Type: application/octet-stream" --data-binary @${CIRCLE_ARTIFACTS}/${ASSET_NAME} https://uploads.github.com/repos/${GITHUB_PROJECT}/releases/${RELEASE_ID}/assets?name=${ASSET_NAME}
