#!/bin/bash

set -e -o pipefail

if ! which gpg &> /dev/null
then
    echo "Error: gpg not installed." >&2
    echo "Please 'brew install gpg'" >&2
    exit 2
fi

if [ ! -d secrets ]
then
    echo "No secrets directory found.  Did you invoke as scripts/encrypt-secrets.sh?" 1>&2
    exit 1
fi

tar c secrets | gzip > secrets.tar.gz
rm -f secrets.tar.gz.gpg
if [ -n "${SECRETS_PASSWORD}" ]
then
    gpg \
        --quiet \
        --cipher-algo AES256 \
        --batch \
        --passphrase "${SECRETS_PASSWORD}" \
        --symmetric secrets.tar.gz
else
    gpg \
        --quiet \
        --cipher-algo AES256 \
        --symmetric secrets.tar.gz
fi
rm -f secrets.tar.gz
