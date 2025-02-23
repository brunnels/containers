#!/usr/bin/env bash
version=$(curl -A "brunnels/containers" -sX GET "https://repology.org/api/v1/projects/?search=transmission&inrepo=alpine_3_21" | jq -r '.transmission | .[] | select((.repo == "alpine_3_21" and .binname == "transmission-daemon")) | .origversion')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
