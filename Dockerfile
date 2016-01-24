FROM iverasp/runit

EXPOSE 5432/tcp

# We forcefully remove logrotate dependency, see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=714982
RUN apt-get update -q -q && \
 echo locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8 | debconf-set-selections && \
 echo locales locales/default_environment_locale select en_US.UTF-8 | debconf-set-selections && \
 apt-get install postgresql --no-install-recommends --yes --force-yes && \
 dpkg --force-depends --remove logrotate && \
 sed -r -i 's/^(Depends: postgresql.*), logrotate \(.*\)(.*)/\1\2/' /var/lib/dpkg/status && \
 apt-get autoremove --yes --force-yes && \
 mkdir -m 700 /var/lib/postgresql.orig && \
 mv /var/lib/postgresql/* /var/lib/postgresql.orig/ && \
 echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf && \
 echo 'hostssl all all 0.0.0.0/0 md5' >> /etc/postgresql/9.1/main/pg_hba.conf

COPY ./etc /etc

RUN chmod +x /etc/service/postgresql/log/run
RUN chmod +x /etc/service/postgresql/run
