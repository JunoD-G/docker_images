# icingadb.Dockerfile
# 
# Revision 12-31-2022 00:52

FROM ubuntu:22.04 AS jammy-base
RUN apt update;\
        apt -y install apt-utils apt-transport-https wget gnupg;\
        apt clean

ADD jammy-icinga.list /etc/apt/sources.list.d/jammy-icinga.list
ADD icinga.key /etc/apt/keyrings/icinga.key
RUN apt update

RUN mkdir /etc/icingadb
RUN chown -vR 101:101 /etc/icingadb
RUN apt install --no-install-recommends -y icingadb;\
        apt clean
RUN apt-get clean && rm -vrf /var/lib/apt/lists/*

CMD ["icingadb", "--config", "/etc/icingadb/config.yml"]