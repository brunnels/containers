#!/usr/bin/dumb-init /bin/bash
set -e

PROJECTOR_DIR="${PROJECTOR_DIR:-/usr/share/projector}"
USER_PROJECTOR_DIR="${USER_PROJECTOR_DIR:-$HOME/.projector}"

PYCHARM_VERSION="${PYCHARM_VERSION:-2024.1.6}"
PYCHARM_VARIANT="${PYCHARM_VARIANT:-community}"
PYCHARM="${PYCHARM:-pycharm-${PYCHARM_VARIANT}-${PYCHARM_VERSION}}"
PYCHARM_URL="${PYCHARM_URL:-https://download.jetbrains.com/python/${PYCHARM}.tar.gz}"

PROJECTOR_VERSION="${PROJECTOR_VERSION:-1.8.2}"
PROJECTOR_SERVER="${PROJECTOR_SERVER:-projector-server-${PROJECTOR_VERSION}}"
PROJECTOR_SERVER_URL="${PROJECTOR_SERVER_URL:-https://github.com/brunnels/projector-server/releases/download/v${PROJECTOR_VERSION}/projector-server-v${PROJECTOR_VERSION}.zip}"

source /usr/bin/projector_init.sh
run_projector
