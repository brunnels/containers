FROM busybox as gpg
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O /tmp/ACCC4CF8.asc

FROM python:3.12-slim-bookworm as base
COPY --from=gpg /tmp/ACCC4CF8.asc /etc/apt/trusted.gpg.d/pgdg.asc

RUN export DEBIAN_FRONTEND=noninteractive \
    && export TERM=xterm \
    && echo "deb https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update 1>/dev/null \
    && apt-get -qq install -y --no-install-recommends gcc g++ libffi-dev libldap2-dev libsasl2-dev libssl-dev libpq5 bash-completion \
       whiptail rsync dnsutils net-tools vim htop inetutils-ping shellcheck postgresql-client-common postgresql-client-16 procps \
       build-essential libxml2-dev libxslt-dev libpq-dev libsecret-1-0 git libxext6 libxrender1 libxtst6 libxi6 libfreetype6 \
       dumb-init curl wget unzip gnupg git jq locales apt-utils ca-certificates apt-transport-https xsltproc 1>/dev/null \
    && locale-gen en_US.UTF-8 UTF-8 C.UTF-8 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true \
    && rm -rf ~/.cache

FROM base as files

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV CT_USER_NAME="${CT_USER_NAME:-dev}"\
    CT_USER_GID="${CT_USER_GID:-568}"\
    CT_USER_UID="${CT_USER_UID:-568}"\
    PROJECTOR_DIR="${PROJECTOR_DIR:-/usr/share/projector}"\
    LC_ALL=C.UTF-8\
    LANG=en_US.UTF-8\
    LANGUAGE=en_US.UTF-8

COPY ./apps/projector-pycharm/static $PROJECTOR_DIR

RUN mv "$PROJECTOR_DIR/projector_init.sh" "$PROJECTOR_DIR/entrypoint.sh" /usr/bin \
    && chmod 755 "$PROJECTOR_DIR" \
    && chmod 644 "$PROJECTOR_DIR/"* \
    && chmod a+rx /usr/bin/projector_init.sh /usr/bin/entrypoint.sh "$PROJECTOR_DIR/ide-projector-launcher.sh" \
    && addgroup --gid $CT_USER_GID "$CT_USER_NAME" \
    && adduser --disabled-password --gecos "" --ingroup "$CT_USER_NAME" --uid "$CT_USER_GID" "$CT_USER_NAME"

USER $CT_USER_NAME
ENV HOME="/home/$CT_USER_NAME"
WORKDIR $HOME
EXPOSE 8887
CMD ["/usr/bin/entrypoint.sh"]
