FROM python:3.12-slim-bookworm AS base

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

# upgrade and add certs
RUN apt-get update && \
    apt-get upgrade --yes --no-install-recommends --no-install-suggests && \
    apt-get install --yes --no-install-recommends --no-install-suggests ca-certificates curl

# add docker repo
RUN install -d /usr/share/docker-archive/docker \
 && curl -s -o /usr/share/docker-archive/docker/apt.download.docker.com.asc --fail https://download.docker.com/linux/debian/gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/docker-archive/docker/apt.download.docker.com.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release; echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list

# add postgres repo
RUN install -d /usr/share/postgresql-common/pgdg \
 && curl -s -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc \
 && echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt \
    $(. /etc/os-release; echo $VERSION_CODENAME)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# add backports repo
RUN echo "deb http://deb.debian.org/debian $(. /etc/os-release; echo $VERSION_CODENAME)-backports main" > /etc/apt/sources.list.d/debian-backports.list

#install packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests apt-transport-https apt-utils bash bash-completion \
    build-essential containerd.io dnsutils docker-buildx-plugin docker-ce docker-ce-cli docker-compose-plugin \
    dumb-init gnupg htop inetutils-ping jq libffi-dev libfontconfig1 libfreetype6 libldap2-dev libpq-dev libpq5 libsasl2-dev \
    libsecret-1-0 libssl-dev libxi6 libxml2-dev libxrender1 libxslt1-dev libxss1 libxtst6 locales man net-tools \
    postgresql-client-16 postgresql-client-17 postgresql-client-common procps rsync shellcheck \
    software-properties-common sudo systemd systemd-sysv unzip vim wget whiptail xsltproc \
 && apt-get install -y -t "$(. /etc/os-release; echo $VERSION_CODENAME)-backports" git \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin \
 && rm -rf ~/.cache

# Enables Docker starting with systemd
RUN systemctl enable docker

# Create a symlink for standalone docker-compose usage
RUN ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose

# Generate the desired locale (en_US.UTF-8)
RUN locale-gen en_US.UTF-8

# add user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --groups=docker \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

# add projector
ENV PROJECTOR_DIR=/usr/share/projector
COPY ./apps/coder-projector-pycharm/static $PROJECTOR_DIR
RUN mv "$PROJECTOR_DIR/projector_init.sh" "$PROJECTOR_DIR/entrypoint.sh" /usr/bin \
    && chmod 755 "$PROJECTOR_DIR" \
    && chmod 644 "$PROJECTOR_DIR/"* \
    && chmod a+rx /usr/bin/projector_init.sh /usr/bin/entrypoint.sh "$PROJECTOR_DIR/ide-projector-launcher.sh"

FROM base AS files

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER coder
ENV CT_USER_NAME=coder\
    CT_USER_GID=1000\
    CT_USER_UID=1000\
    PROJECTOR_DIR=/usr/share/projector\
    PYCHARM_VERSION="$VERSION"\
    LC_ALL=C.UTF-8\
    LANG=en_US.UTF-8\
    LANGUAGE=en_US.UTF-8
ENV HOME="/home/coder"
WORKDIR $HOME
