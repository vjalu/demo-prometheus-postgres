ARG PG_SERVER_VERSION=14

FROM postgres:${PG_SERVER_VERSION}-alpine
ENV LANG fr_FR.utf8

ENV PG_SERVER_VERSION=${PG_SERVER_VERSION}

RUN apk update && apk upgrade && \
    apk add --no-cache  \ 
    curl openssh curl ca-certificates pgbackrest postgresql-pg_cron


# Copie base config
COPY postgresql.tmpl.conf  /tmp/postgresql.conf


#COPY config/id_rsa /root/.ssh/
#RUN chmod 600 ~/.ssh/id_rsa


RUN mkdir -p /srv/backup/physique &&\
    mkdir -p /srv/backup/logique &&\
    mkdir -p /srv/backup/restore  &&\
    mkdir -p /srv/scripts  &&\
    chown -R postgres:postgres  /srv/backup/  &&\
    chmod -R 775 /srv/backup  &&\
    chown -R postgres:postgres  /srv/scripts/  &&\
    chmod -R 775 /srv/scripts

#RUN pgbackrest --stanza=backup-vince--log-level-console=info --pg1-path=/var/lib/postgresql/data stanza-create
COPY pgbackrest.conf  /tmp/pgbackrest.conf
COPY pgbackrest.conf  /etc/postgres/postgresql.conf
#COPY pgsql_backup.sh /mnt/backup/postgres/pgsql_backup.sh

RUN chown -R postgres:postgres /etc/pgbackrest/ &&\
    chmod -R 755 /etc/pgbackrest/

# Apply cron job
COPY cronjobs /etc/crontabs/root
RUN crontab /etc/crontabs/root

