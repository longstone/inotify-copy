#!/bin/sh

 cd "/in"
 echo "Startup $(date)"
 echo "Working with id: $(id) and in directory $(pwd)"
 echo "Starting the work with /in and /out ... "

 while true; do
   ## Watch for new files, the grep will return true if a file has
    inotifywait -m . -e create -e moved_to | while read PATH ACTION FILE
    do
         echo "$(/bin/date): event $ACTION, detected file: $FILE, sleeping for 10 Seconds"
         /bin/sleep 10s
         /bin/cp -v "/in/$FILE" "/out"
    done
 done
