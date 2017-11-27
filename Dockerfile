FROM centos:7

RUN yum install -y gcc glibc-static tmux git \
    && cd /usr/src/ \
    && git clone git://github.com/c9/core.git c9sdk \
    && cd c9sdk \
    && scripts/install-sdk.sh \
    && yum remove -y gcc cpp glibc-devel glibc-headers kernel-headers libmpc mpfr glibc-static

ENV WORKSPACE_DIR /root/
ENV IP_ADDR 0.0.0.0
ENV USERNAME ""
ENV PASSWORD ""

WORKDIR /usr/src/c9sdk
EXPOSE 8080

CMD ["/root/.c9/node/bin/node","server.js","-p","8080","-l","$IP_ADDR","-w","$WORKSPACE_DIR","-a","$USERNAME:$PASSWORD"]
