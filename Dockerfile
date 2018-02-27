FROM alpine:3.7

ENV MONGO_URL mongodb://mongo
ENV BACKUP_LEFETIME 10
ENV BACKUP_PATH /data/backup
ENV BACKUP_SHEDULE "0     4     *     *     *"

VOLUME ${BACKUP_PATH}

RUN set -ex; \
# Install mongodb-tools
    apk add --no-cache mongodb-tools; \
    \
# Download supercronic
    export \
      SUPERCRONIC_URL_ROOT=https://github.com/aptible/supercronic \
      SUPERCRONIC_URL_PATH=releases/download/v0.1.5/supercronic-linux-amd64 \
      SUPERCRONIC=/usr/bin/supercronic \
      SUPERCRONIC_SHA1SUM=9aeb41e00cc7b71d30d33c57a2333f2c2581a201; \
    \
    wget "${SUPERCRONIC_URL_ROOT}/${SUPERCRONIC_URL_PATH}" -O ${SUPERCRONIC}; \
    echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - ; \
    chmod +x "$SUPERCRONIC"


COPY scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

WORKDIR ${BACKUP_PATH}

CMD ["start-supercronic"]