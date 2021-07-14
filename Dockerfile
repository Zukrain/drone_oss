FROM debian:buster-slim

LABEL maintainer="vl@zukrain.ru"
LABEL description="Based on the official build of Debian Buster(slim) + Drone OSS v.2.0.4"

RUN set -ex \
    && install -d -m0755 /data

ENV GODEBUG netdns=go
ENV XDG_CACHE_HOME /data
ENV DRONE_DATABASE_DRIVER sqlite3
ENV DRONE_DATABASE_DATASOURCE /data/database.sqlite
ENV DRONE_SERVER_PORT=:80
ENV DRONE_SERVER_HOST=localhost
ENV DRONE_AGENTS_DISABLED=true
ENV DRONE_REPOSITORY_TRUSTED=true

VOLUME /data
COPY drone-server /bin

EXPOSE 80
ENTRYPOINT ["/bin/drone-server"]
