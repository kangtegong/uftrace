#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

file="$1"

signedoff_regex='^Signed-off-by: '

if [ "$(grep -c "$signedoff_regex" "$file")" != "1" ]; then
        exit 1
fi
