#/bin/bash -e

mkdir -p /srv/var/log/postgresql
mkdir -p /srv/postgresql

docker run -d --restart=always --name pgsql --hostname pgsql -v /srv/var/hosts:/etc/hosts:ro -v /srv/var/log/postgresql:/var/log/postgresql -v /srv/postgresql:/var/lib/postgresql iverasp/postgresql

