# alpine-php.Dockerfile
#
# Revision 01-21-2023 20:40

FROM alpine:3.17.1 AS alpine

RUN apk update;\
    apk add --no-cache bash \
        tzdata
RUN echo "America/Chicago" > /etc/timezone
RUN cp -v /usr/share/zoneinfo/US/Central /etc/localtime
RUN apk del tzdata

FROM alpine AS alpine-php

RUN apk add --no-cache \
    php81-fpm \
    php81-gd \
    php81-pgsql \
    php81-mysqlnd \
    php81-opcache \
    php81-curl

ENTRYPOINT ["/data/run.sh"]