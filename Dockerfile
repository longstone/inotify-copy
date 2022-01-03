FROM alpine

RUN apk add --no-cache inotify-tools
COPY ./watch.sh /bin/watch.sh

CMD ["/bin/sh","/bin/watch.sh"]
