## FROM daocloud.io/python:2.7
FROM daocloud.io/library/alpine:latest

MAINTAINER JiangLong <jianglong1@cmbc.com.cn>

#RUN mkdir /code
#  && \
#apt-get update && \
#apt-get install -y nginx && \
#rm -rf /var/lib/apt/lists/*
#WORKDIR /code

#WORKDIR /code

#ADD requirements.txt /code/requirements.txt
#RUN pip install -r /code/requirements.txt
#COPY . /code
#COPY docker-entrypoint.sh docker-entrypoint.sh
#RUN chmod +x docker-entrypoint.sh

#EXPOSE 8888

#CMD /code/docker-entrypoint.sh


ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-5.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-2.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories \
    && echo "http://dl-3.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories \
    && echo "http://dl-5.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories \
    && apk --update add -y vim wget bzip2 ca-certificates git mercurial subversion curl grep sed dpkg \
    && echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
    && wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh
    
RUN echo "========================================" \
    && head -370 ~/anaconda.sh | tail -20 \
    && echo "========================================" \
    && /bin/sh ~/anaconda.sh -b -p /opt/conda \
    && rm ~/anaconda.sh
    
RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` \
    && curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb \
    && dpkg -i tini.deb \
    && rm tini.deb

#libglib2.0-0 libxext6 libsm6 libxrender1 

ENV PATH /opt/conda/bin:$PATH

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
