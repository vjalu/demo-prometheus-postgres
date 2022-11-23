ARG PG_SERVER_VERSION=14

FROM postgres:${PG_SERVER_VERSION}-alpine
ENV LANG fr_FR.utf8

ENV PG_SERVER_VERSION=${PG_SERVER_VERSION}

RUN apk update && apk upgrade && \
    apk add --no-cache  \ 
    curl openssh curl ca-certificates pgbackrest postgresql-pg_cron


