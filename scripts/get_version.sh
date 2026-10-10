#!/bin/bash
set -eou pipefail

UPSTREAM_OWNER=flannel-io
UPSTREAM_REPO=flannel

curl -s https://api.github.com/repos/"$UPSTREAM_OWNER"/"$UPSTREAM_REPO"/releases/latest \
     | jq -r ".tag_name"
