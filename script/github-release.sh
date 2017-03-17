#!/usr/bin/env bash#
#
# Script to create and upload a release asset using the GitHub API v3.
# Parameters: owner, repo, tag, filename, github_api_token
#
# Example:
# github-release.sh github_api_token=TOKEN owner=gaia-docker repo=base-go-build tag=v0.1.0 filename=./build.zip
#

# Check dependencies
set -e
xargs=$(which gxargs || which xargs)

# Validate settings
[ "$TRACE" ] && set -x

CONFIG=$@

for line in $CONFIG; do
  eval "$line"
done

# Define variables
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$owner/$repo"
GH_TAGS="$GH_REPO/releases/tags/$tag"
AUTH="Authorization: token $github_api_token"
WGET_ARGS="--content-disposition --auth-no-challenge --no-cookie"
CURL_ARGS="-LJO#"

if [[ "$tag" == 'LATEST' ]]; then
  GH_TAGS="$GH_REPO/releases/latest"
fi

curl -i -H "Content-Type: application/json" -H "Authorization: token $github_api_token" -X POST -d '{"tag_name": "'$tag'", "target_commitish": "master", "name": "'$tag'", "body": "", "draft": false, "prerelease": false}' "$GH_REPO"/releases

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Read asset tags.
response=$(curl -sH "$AUTH" $GH_TAGS)

# Get ID of the asset based on given filename.
eval $(echo "$response" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
[ "$id" ] || { echo "Error: Failed to get release id for tag: $tag"; echo "$response" | awk 'length($0)<100' >&2; exit 1; }

# Upload asset
echo "Uploading asset... $localAssetPath" >&2

# Construct url
GH_ASSET="https://uploads.github.com/repos/$owner/$repo/releases/$id/assets?name=$(basename $filename)"

curl "$GITHUB_OAUTH_BASIC" --data-binary @"$filename" -H "Authorization: token $github_api_token" -H "Content-Type: application/octet-stream" $GH_ASSET