#!/usr/bin/env bash

set -e

jbang_version=`ls build/distributions/jbang-*.*.zip | sed -e 's/.*jbang-\(.*\).zip/\1/g'`
echo "Updating jbang sdkman with version $jbang_version"


echo ${SDKMAN_CONSUMER_KEY} | cut -c-5
echo ${SDKMAN_CONSUMER_TOKEN} | cut -c-5

echo "Release on sdkman ${jbang_version} from `pwd`"
curl -X POST \
    -H "Consumer-Key: ${SDKMAN_CONSUMER_KEY}" \
    -H "Consumer-Token: ${SDKMAN_CONSUMER_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"candidate": "jbang", "version": "'${jbang_version}'", "url": "https://github.com/jbangdev/jbang/releases/download/v'${jbang_version}'/jbang-'${jbang_version}'.zip"}' \
    https://vendors.sdkman.io/release

## Set existing Version as Default for Candidate

echo "Set default version on sdkman"
curl -X PUT \
    -H "Consumer-Key: ${SDKMAN_CONSUMER_KEY}" \
    -H "Consumer-Token: ${SDKMAN_CONSUMER_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"candidate": "jbang", "version": "'${jbang_version}'"}' \
    https://vendors.sdkman.io/default

## Broadcast message with pointer to change log
curl -X POST \
    -H "Consumer-Key: ${SDKMAN_CONSUMER_KEY}" \
    -H "Consumer-Token: ${SDKMAN_CONSUMER_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d '{"text": "Jbang '${jbang_version}' released on SDKMAN! See https://github.com/jbangdev/jbang/releases/tag/v'${jbang_version}' #jbang"}' \
    https://vendors.sdkman.io/announce/freeform
