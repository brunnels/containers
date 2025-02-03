ARG NODE_VERSION=22.13.1
ARG VERSION

LABEL org.opencontainers.image.source="https://github.com/softbounce/inbound-email"

FROM node:${NODE_VERSION}-alpine

ENV NODE_ENV="production" \
    PORT="2525" \
    UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app

RUN git clone https://github.com/softbounce/inbound-email.git . \
 && if [ -n "${VERSION}" ]; then \
      NUMBER_COMMITS_TO_REVERT=$(( $(git rev-list --count --first-parent HEAD) - $(echo "${VERSION}" | cut -d "." -f3) )); \
      git checkout "master~${NUMBER_COMMITS_TO_REVERT}"; \
    fi \
 && npm ci --omit=dev

USER node
EXPOSE 2525
CMD node server.js
