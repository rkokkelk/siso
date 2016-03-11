# Dockerfile for building of SISO application
# 

FROM rails:latest
MAINTAINER Roy Kokkelkoren <roy.kokkelkoren@gmail.com>

RUN bin/setup
EXPOSE 3000
ENTRYPOINT bin/run
