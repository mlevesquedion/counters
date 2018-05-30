FROM debian:latest

RUN apt-get -y update
RUN apt-get -y install apt-utils

RUN apt-get -y install curl

RUN apt-get -y install gpg

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential

RUN apt-get install -y nginx

EXPOSE 8000

ADD . /app

WORKDIR /app

RUN npm install elm
RUN npm install elm-live

CMD npx elm-live Main.elm --host=0.0.0.0
