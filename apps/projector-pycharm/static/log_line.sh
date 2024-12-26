#!/bin/bash

ORANGE='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

INFO() {
    echo -e "${GREEN}${*}${NC}"
}

WARN() {
    echo -e "${ORANGE}${*}${NC}"
}

ERROR() {
    echo -e "${RED}${*}${NC}"
}