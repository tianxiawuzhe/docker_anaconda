#FROM debian:8
#FROM daocloud.io/library/ubuntu:latest
FROM daocloud.io/library/alpine:latest

MAINTAINER JiangLong <jianglong1@cmbc.com.cn>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apk --update add --no-cache --virtual=build-dependencies vim wget ca-certificates bash tini

RUN mkdir /software && cd /software && \
    GLIBC_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    GLIBC_VERSION="2.26-r0" && \
    GLIBC_PKG_BASE="glibc-${GLIBC_VERSION}.apk" && \
    GLIBC_PKG_BIN="glibc-bin-${GLIBC_VERSION}.apk" && \
    GLIBC_PKG_I18N="glibc-i18n-${GLIBC_VERSION}.apk" && \
    wget -q "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget -q "${GLIBC_URL}/${GLIBC_VERSION}/${GLIBC_PKG_BASE}" "${GLIBC_URL}/${GLIBC_VERSION}/$GLIBC_PKG_BIN" \
        "${GLIBC_URL}/${GLIBC_VERSION}/$GLIBC_PKG_I18N" && \
    apk add --no-cache "${GLIBC_PKG_BASE}" "${GLIBC_PKG_BIN}" "${GLIBC_PKG_I18N}" && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n
# && \
# rm "${GLIBC_PKG_BASE}" "${GLIBC_PKG_BIN}" "${GLIBC_PKG_I18N}"

#apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
#    libglib2.0-0 libxext6 libsm6 libxrender1 curl grep sed dpkg \
#    git mercurial subversion \
#    && 
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
    && wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

# && TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
#     curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
#     dpkg -i tini.deb && \
#     rm tini.deb && \
#     apt-get clean
ENV PATH /opt/conda/bin:$PATH

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/bin/bash" ]
