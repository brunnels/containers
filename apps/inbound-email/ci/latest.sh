#!/usr/bin/env bash
git clone --quiet https://github.com/softbounce/inbound-email.git /tmp/inbound-email
pushd /tmp/inbound-email > /dev/null || exit
version=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/inbound-email
printf "1.0.%d" "${version}"
