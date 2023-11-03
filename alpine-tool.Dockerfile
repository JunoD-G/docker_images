# alpine-nginx.Dockerfile
# velocitisystemengineer/alpine-tools:0.4.0
# Revision 03-18-2023 15:53

FROM alpine:3.17.2 AS alpine

RUN apk update;\
    apk add --no-cache bash \
        tzdata
RUN echo "America/Chicago" > /etc/timezone
RUN cp -v /usr/share/zoneinfo/US/Central /etc/localtime
RUN apk del tzdata

FROM alpine AS tool

RUN apk add --no-cache \
    bind-tools \     # 9.18.13-r0 -> 9.19
    curl \           # 7.88.1-r1
    nginx \          # 1.22.1-r0 -> 1.23.3
    openssh \        # 9.3_p1-r0
    openssl \        # 3.1.0-r0
    ntpsec \         # 1.2.2-r0
    postgresql15 \   # 15.2-r1
    rsync \          # 3.2.7-r0
    tcpdump          # 4.99.3-r0

RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    php82-curl \     # 8.2.4-r0
    php82-fpm \
    php82-gd \
    php82-mysqlnd \
    php82-opcache \
    php82-pgsql
