#!/bin/sh

cd "/in"
${INOTIFY_COPY_DELAY:=0}
echo "$(date): Startup"
echo "$(date): Working with id: $(id) and in directory $(pwd)"
echo "$(date): Starting the work with /in and /out ... "
echo "$(date): INOTIFY_COPY_DELAY: $INOTIFY_COPY_DELAY"
INOTIFY_COPY_DELAY=$INOTIFY_COPY_DELAY;
while true; do
  # Watch for new files
  inotifywait -m . -e create -e moved_to | while read PATH ACTION FILE
  do
       echo "$(/bin/date): event $ACTION, detected file: $FILE, copy it in $INOTIFY_COPY_DELAY Seconds"
       (/bin/sleep "$INOTIFY_COPY_DELAY"; /bin/cp -v "/in/$FILE" "/out") &
  done
done
