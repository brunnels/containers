#!/bin/bash
set -e

source "${PROJECTOR_DIR}/log_line.sh"

setup_user_home() {
    if [ ! -f "$HOME/.inputrc" ] ; then
        echo '$include /etc/inputrc' > "$HOME/.inputrc"
        echo '"\e[A": history-substring-search-backward' >> "$HOME/.inputrc"
        echo '"\e[B": history-substring-search-forward' >> "$HOME/.inputrc"
        echo 'set show-all-if-ambiguous on' >> "$HOME/.inputrc"
        echo 'set completion-ignore-case on' >> "$HOME/.inputrc"
    fi

    if [ ! -f "$HOME/.profile" ] ; then
        cp /etc/skel/.* "$HOME/"
    fi

    if cmp --silent -- "/etc/skel/.bashrc" "$HOME/.bashrc"; then
        INFO "Updating .bashrc for user '$CT_USER_NAME'..."
        cat "$PROJECTOR_DIR/.bashrc" >> "$HOME/.bashrc"
    fi

    if [ ! -f "$HOME/.local/bin/task" ]; then
        INFO "Installing go-task for user '$CT_USER_NAME'..."
        sh -c "$(curl -s --location https://taskfile.dev/install.sh)" -- -d -b "$HOME/.local/bin" &>/dev/null
    fi
}


install_pycharm_profile() {
    if is_pycharm_configured; then
        WARN "Found existing profile for $PYCHARM.  Not installing the default profile"
    else
        if [ -f "$PROJECTOR_DIR/pycharm-community-profile.tgz" ]; then
            INFO "Installing $PYCHARM default profile..."
            tar -C "$HOME" -xzf "$PROJECTOR_DIR/pycharm-community-profile.tgz" --no-same-owner --strip-components 1
        else
            WARN "Default profile not found for $PYCHARM!  You're on your own!"
        fi
    fi
}

install_pycharm_projector() {
    if ! is_pycharm_installed; then
        rm -rf "${USER_PROJECTOR_DIR:?}/$PYCHARM" || true
        INFO "Downloading $PYCHARM.tar.gz..."
        wget "$PYCHARM_URL" -qO /tmp/pycharm.tar.gz
        if [ -f "/tmp/pycharm.tar.gz" ]; then
            INFO "Installing $PYCHARM.tar.gz..."
            mkdir -p "$USER_PROJECTOR_DIR/$PYCHARM"
            tar -C "$USER_PROJECTOR_DIR/$PYCHARM" -xzf /tmp/pycharm.tar.gz --no-same-owner --strip-components 1
            chown -R "$CT_USER_NAME": "$USER_PROJECTOR_DIR/$PYCHARM"
            rm /tmp/pycharm.tar.gz
        fi

        install_pycharm_profile

        chown -R "$CT_USER_NAME": "$USER_PROJECTOR_DIR/$PYCHARM"
    else
        WARN "$PYCHARM already installed in $USER_PROJECTOR_DIR/$PYCHARM.  Delete or rename this directory to re-install"
    fi

    mkdir -p "$USER_PROJECTOR_DIR/$PYCHARM/bin"
    cp "$PROJECTOR_DIR/ide-projector-launcher.sh" "$USER_PROJECTOR_DIR/$PYCHARM/bin"
    chmod a+rx "$USER_PROJECTOR_DIR/$PYCHARM/bin/ide-projector-launcher.sh"

    if ! is_projector_installed; then
        rm -rf "${USER_PROJECTOR_DIR:?}/$PROJECTOR_SERVER" || true
        INFO "Downloading $PROJECTOR_SERVER.tar.gz..."
        wget "${PROJECTOR_SERVER_URL}" -qO /tmp/projector-server.zip
        if [ -f "/tmp/projector-server.zip" ]; then
            INFO "Installing $PROJECTOR_SERVER.zip..."
            unzip -qq "/tmp/projector-server.zip" -d "$USER_PROJECTOR_DIR"
            chown -R "$CT_USER_NAME": "$USER_PROJECTOR_DIR/$PROJECTOR_SERVER"
            rm "/tmp/projector-server.zip"
        fi
    else
        WARN "$PROJECTOR_SERVER already installed in $USER_PROJECTOR_DIR/$PROJECTOR_SERVER.  Delete or rename this directory to re-install"
    fi
    rm "$USER_PROJECTOR_DIR/$PYCHARM/projector-server" &>/dev/null || true
    ln -s "$USER_PROJECTOR_DIR/$PROJECTOR_SERVER" "$USER_PROJECTOR_DIR/$PYCHARM/projector-server"
}

is_pycharm_installed() {
    IDE_DIR="$USER_PROJECTOR_DIR/$PYCHARM"

    DIRS=("$IDE_DIR/bin" "$IDE_DIR/lib" "$IDE_DIR/jbr/bin" "$IDE_DIR/jbr/conf" "$IDE_DIR/jbr/lib")
    for DIR in "${DIRS[@]}"; do
        [ "$(ls -A "$DIR" 2>/dev/null)" ] || return 1
    done

    [ -f "$IDE_DIR/bin/ide-projector-launcher.sh" ] || return 1

    return
}

is_pycharm_configured() {
    if [ -z "$PYCHARM_CONFIG_DIR" ] && [ -d "$HOME/.config/JetBrains" ]; then
        PYCHARM_CONFIG_DIR="$(find "$HOME/.config/JetBrains" -type d -name "PyCharm*" | sort -n | tail -1)"
    fi

    if [ -n "$PYCHARM_CONFIG_DIR" ] && [ -d "$PYCHARM_CONFIG_DIR" ]; then
        return
    fi
    return 1
}

is_projector_installed() {
    INSTALL_DIR="$USER_PROJECTOR_DIR/$PROJECTOR_SERVER"

    DIRS=("$INSTALL_DIR/bin" "$INSTALL_DIR/lib")
    for DIR in "${DIRS[@]}"; do
        [ "$(ls -A "$DIR" 2>/dev/null)" ] || return 1
    done

    return
}

run_projector() {
    install_pycharm_projector
    if is_projector_installed && is_pycharm_installed; then
        find "$HOME/.config/JetBrains" -type f -name ".lock" -exec rm {} \; || true
        setup_user_home
        cd "$USER_PROJECTOR_DIR/$PYCHARM/bin"
        bash ide-projector-launcher.sh
        return
    fi
    return 1
}
