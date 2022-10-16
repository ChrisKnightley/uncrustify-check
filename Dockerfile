FROM alpine:latest

RUN apk add git uncrustify 

ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT "/entrypoint.sh"
