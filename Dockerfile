# Dockerfile for building of SISO application
FROM ruby:2.2
MAINTAINER Roy Kokkelkoren <roy.kokkelkoren@gmail.com>

RUN mkdir -p /usr/src/siso
WORKDIR /usr/src/siso

ONBUILD COPY . /usr/src/siso
ONBUILD RUN bin/setup

RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

EXPOSE 3000
CMD ["bin/setup"]
