## FROM daocloud.io/python:2.7
FROM continuumio/anaconda3:lastest

MAINTAINER JiangLong <jianglong1@cmbc.com.cn>

RUN mkdir /code
#  && \
#apt-get update && \
#apt-get install -y nginx && \
#rm -rf /var/lib/apt/lists/*
#WORKDIR /code

WORKDIR /code

#ADD requirements.txt /code/requirements.txt
#RUN pip install -r /code/requirements.txt
COPY . /code
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 8888

CMD /code/docker-entrypoint.sh

