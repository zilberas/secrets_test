#!/bin/bash

set -eu -o pipefail

if ! which gpg &> /dev/null
then
    echo "Error: gpg not installed." >&2
    echo "Please 'brew install gpg'" >&2
    exit 2
fi

if [ -n "${SECRETS_PASSWORD}" ]
then
    gpg \
        --quiet \
        --cipher-algo AES256 \
        --batch \
        --passphrase "${SECRETS_PASSWORD}" \
        secrets.tar.gz.gpg
else
    gpg \
        --quiet \
        --cipher-algo AES256 \
        secrets.tar.gz.gpg
fi

rm -rf secrets
cat secrets.tar.gz | gunzip | tar x
rm -f secrets.tar.gz
