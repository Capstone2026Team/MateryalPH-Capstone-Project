FROM postgis/postgis:16-3.5
ENV PGDATA=/var/lib/postgresql/data/pgdata
COPY infrastructure/docker/postgres-staging-init.sh /docker-entrypoint-initdb.d/99-staging-app.sh
COPY infrastructure/docker/postgres-staging-start.sh /usr/local/bin/staging-postgres-start
RUN test -f /docker-entrypoint-initdb.d/10_postgis.sh \
    && rm /docker-entrypoint-initdb.d/10_postgis.sh \
    && chmod +x /docker-entrypoint-initdb.d/99-staging-app.sh /usr/local/bin/staging-postgres-start
CMD ["/usr/local/bin/staging-postgres-start"]
