# icingaweb.Dockerfile
#
# Revision 08-17-2023 21:47

FROM alpine:3.18 AS alpine

RUN apk update;\
    apk add --no-cache bash \
        tzdata
RUN echo "America/Chicago" > /etc/timezone
RUN cp -v /usr/share/zoneinfo/US/Central /etc/localtime
RUN apk del tzdata

FROM alpine AS alpine-php

RUN apk add --no-cache \
    icu-libs

RUN apk add --no-cache \
    php81-fpm \
    php81-curl \
    php81-gd \
    php81-gmp \
    php81-mbstring \
    php81-mysqlnd \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-pecl-imagick \
    php81-pgsql \
    php81-posix \
    php81-xml

FROM alpine-php AS icingaweb2

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    icingaweb2 \
    icingaweb2-doc \
#    icinga-php-library \
#    icinga-php-library-doc \
    icinga-php-thirdparty \
    icinga-php-thirdparty-doc \
    jq \
    supervisor

RUN apk del icinga-php-library \
    icinga-php-library-doc
RUN mv -v /usr/share/icinga-php/ipl /usr/share/ipl-old

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    icingaweb2-module-director \
    icingaweb2-module-director-doc \
    icingaweb2-module-incubator \
    icingaweb2-module-incubator \
    icingaweb2-module-incubator-doc

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    icingaweb2-ldap \
    icingaweb2-mysql-backend \
    icingaweb2-postgres-backend

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    icingaweb2-module-businessprocess \
    icingaweb2-module-businessprocess-doc \
#    icingaweb2-module-fileshipper \
#    icingaweb2-module-fileshipper-doc \
    icingaweb2-module-generictts \
    icingaweb2-module-generictts-doc \
    icingaweb2-module-pnp \
    icingaweb2-module-pnp-doc

RUN apk add git
RUN git clone https://github.com/icinga/icinga-php-library.git /usr/share/icinga-php/ipl --branch v0.12.0
RUN git clone https://github.com/icinga/icingadb-web.git /usr/share/webapps/icingaweb2/modules/icingadb --branch v1.0.2
RUN git clone https://github.com/icinga/icingaweb2-module-x509.git /usr/share/webapps/icingaweb2/modules/x509 --branch v1.2.1
RUN icingacli module enable x509
RUN apk del git

RUN icingacli setup config directory --group icingaweb2
RUN icingacli module enable setup

RUN ln -vsf /dev/stdout /var/log/access.log &&\
        ln -vsf /dev/stderr /var/log/error.log

RUN mkdir -pv /data
ADD icingaweb.run.sh /data/run.sh
RUN chown 100:101 /data/run.sh &&\
    chmod 0755 /data/run.sh

EXPOSE 9000

ENTRYPOINT ["/data/run.sh"]
