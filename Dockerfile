FROM alpine:3.23.3

RUN apk add --no-cache inotify-tools
COPY ./watch.sh /bin/watch.sh

CMD ["/bin/sh","/bin/watch.sh"]
