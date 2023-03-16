FROM alpine:3.17.2

RUN apk add --no-cache inotify-tools
COPY ./watch.sh /bin/watch.sh

CMD ["/bin/sh","/bin/watch.sh"]
