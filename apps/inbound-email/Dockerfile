ARG NODE_VERSION=22.13.1
ARG VERSION

FROM node:${NODE_VERSION}-alpine

ENV NODE_ENV="production" \
    PORT="2525" \
    UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app

RUN apk add --no-cache --virtual=.build-deps git \
 && git clone https://github.com/softbounce/inbound-email.git . \
 && if [ -n "${VERSION}" ]; then \
      NUMBER_COMMITS_TO_REVERT=$(( $(git rev-list --count --first-parent HEAD) - $(echo "${VERSION}" | cut -d "." -f3) )); \
      git checkout "master~${NUMBER_COMMITS_TO_REVERT}"; \
    fi \
 && npm install --omit=dev \
 && chown -R root:root /app && chmod -R 755 /app \
 && apk del --purge .build-deps \
 && rm -rf /root/.cache /root/.cargo /tmp/*

USER node
EXPOSE 2525
CMD node server.js
LABEL org.opencontainers.image.source="https://github.com/softbounce/inbound-email"
