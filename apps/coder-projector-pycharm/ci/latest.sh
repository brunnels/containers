#!/usr/bin/env bash
MAJOR="2024.1"
LATEST="$(curl -s https://data.services.jetbrains.com/products/releases?code=PC | jq -r "[ .PCP[] | select( .majorVersion == \"${MAJOR}\") ] | .[0].version")"
printf "%s" "$LATEST"
