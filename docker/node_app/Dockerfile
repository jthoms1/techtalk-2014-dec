FROM ubuntu:12.04

RUN apt-get install curl -y > /dev/null
RUN curl -sL https://deb.nodesource.com/setup | bash - > /dev/null
RUN apt-get install nodejs -y > /dev/null

COPY ../../app /src

RUN cd /src; npm install

EXPOSE 3000

CMD ["node", "/src/server.js"]
