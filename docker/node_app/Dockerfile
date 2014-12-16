FROM ubuntu:12.04

RUN apt-get update -y && apt-get install git supervisor curl build-essential -y > /dev/null
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /data
RUN mkdir -p /logs

RUN cd /opt && git clone https://github.com/jthoms1/techtalk-2014-dec.git

RUN curl -sL https://deb.nodesource.com/setup | bash - > /dev/null
RUN apt-get install nodejs -y > /dev/null

ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

EXPOSE 3000

CMD "/usr/bin/supervisord"

