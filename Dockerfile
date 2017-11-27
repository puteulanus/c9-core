FROM centos:7

RUN yum install -y gcc glibc-static make \
    && yum -y install tmux git \
    && cd /usr/src/ \
    && git clone git://github.com/c9/core.git c9sdk \
    && cd c9sdk \
    && scripts/install-sdk.sh \
    && yum install -y python-setuptools python-devel gcc-c++ \
    && easy_install pip \
    && pip install -U virtualenv \
    && virtualenv --python=python2 /root/.c9/python2 \
    && source /root/.c9/python2/bin/activate \
    && mkdir /tmp/codeintel \
    && pip download -d /tmp/codeintel codeintel==0.9.3 \
    && cd /tmp/codeintel \
    && tar xf CodeIntel-0.9.3.tar.gz \
    && mv CodeIntel-0.9.3/SilverCity CodeIntel-0.9.3/silvercity \
    && tar czf CodeIntel-0.9.3.tar.gz CodeIntel-0.9.3 \
    && pip install -U --no-index --find-links=/tmp/codeintel codeintel \
    && rm -rf /tmp/codeintel \
    && yum remove -y gcc cpp glibc-devel glibc-headers kernel-headers libgomp libmpc mpfr \
        glibc-static gcc-c++ libstdc++-devel

ENV WORKSPACE_DIR /root/
ENV C9_IP 0.0.0.0
ENV C9_PORT 8080
ENV USERNAME ""
ENV PASSWORD ""

WORKDIR /usr/src/c9sdk
EXPOSE 8080

CMD /root/.c9/node/bin/node server.js -l $C9_IP -p $C9_PORT -w $WORKSPACE_DIR -a $USERNAME:$PASSWORD
