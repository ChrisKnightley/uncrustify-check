FROM alpine:latest

RUN apk add git uncrustify bash

ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT "/entrypoint.sh"
