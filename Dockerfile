FROM alpine:3.4

# setup external informations
ENV TNDHM_PKG tndhm_devkit_c-20140627
ENV TNDHM_TGZ ${TNDHM_PKG}.tar.gz
#ENV TNDHM_TGZ_URL http://uecda.nishino-lab.jp/files/${TNDHM_TGZ}
ENV TNDHM_TGZ_URL http://www.tnlab.inf.uec.ac.jp/daihinmin/2016/files/${TNDHM_TGZ}

# use strict
RUN set -xeuo pipefail \

# install build kit & libx
    && apk add --no-cache \
        wget g++ make \
        libx11-dev libxpm-dev libxt-dev libxaw-dev \

# get uecda source code
    && mkdir /uecda \
    && cd /uecda \
    && wget $TNDHM_TGZ_URL \
    && tar xvzf $TNDHM_TGZ \
    && rm $TNDHM_TGZ \

# build uecda server
    && cd /uecda/${TNDHM_PKG}/server \
    && ./configure --enable-static \
    && make \

# move uecda product
    && mv src/tndhms /uecda/ \
    && mv src/tndhms.cfg /uecda/ \
    && mv src/*.xpm /uecda/ \

# disable outputting debug files
    && touch /uecda/debug.dat  \
    && touch /uecda/debug2.dat \
    && chmod 000 /uecda/debug.dat  \
    && chmod 000 /uecda/debug2.dat \

# remove uecda source code
    && cd /uecda \
    && rm -r ${TNDHM_PKG} \

# uninstall build kit & part of libx
    && mv /usr/lib/libXpm.so.4.11.0 /usr/lib/libXpm.so.4.bak \
    && apk del --nocache --purge -r \
        wget g++ make \
        libxpm-dev libxt-dev libxaw-dev \
    && mv /usr/lib/libXpm.so.4.bak  /usr/lib/libXpm.so.4 \
    && rm -r /usr/include \
    && rm /usr/lib/*.a

# boot
WORKDIR /uecda
EXPOSE 42485
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["./tndhms"]
