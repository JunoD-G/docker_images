# /data/bind/alpine-bind.Dockerfile
# Revision 10-29-2022 13:38
FROM alpine:3.16.2
RUN apk update
RUN apk add --no-cache bind
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]