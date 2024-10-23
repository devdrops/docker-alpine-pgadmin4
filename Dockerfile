# syntax=docker/dockerfile:1
FROM python:alpine3.20

# Image information
ARG VCS_REF
ARG BUILD_DATE
ARG BUILD_VERSION
ARG VERSION
ARG PGADMIN_VERSION
ARG PGADMIN_WHL

LABEL maintainer="Davi Marcondes Moreira <davi.marcondes.moreira@gmail.com>" \
      org.label-schema.name="DevDrops/pgAdmin4" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.license="PostgreSQL" \
      org.label-schema.url="https://www.pgadmin.org" \
      org.label-schema.vcs-url="https://github.com/devdrops/docker-pgadmin4" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-version=$BUILD_VERSION \
      org.label-schema.project-version=$VERSION

ENV PGADMIN4_VERSION=3.0
ENV PGADMIN4_DOWNLOAD_URL=https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$PGADMIN_VERSION/pip/$PGADMIN_WHL.whl

RUN set -ex \
    apk update && \
    apk upgrade && \
	  apk add --no-cache --virtual .pgadmin4-rundeps \
      bash \
      postgresql \
    --repository=https://dl-cdn.alpinelinux.org/alpine/latest-stable/main && \
    apk del .pgadmin4-rundeps && \
    rm -rf /var/cache/apk/* && \
	  apk add --no-cache --virtual .build-deps \
      gcc \
      musl-dev \
      postgresql-dev && \
	  pip --no-cache-dir install $PGADMIN4_DOWNLOAD_URL && \
	  apk del .build-deps

VOLUME /var/lib/pgadmin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5050
CMD ["pgadmin4"]
