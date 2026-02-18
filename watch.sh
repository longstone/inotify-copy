#!/bin/sh
set -eu

IN_DIR="${IN_DIR:-/in}"
OUT_DIR="${OUT_DIR:-/out}"
: "${INOTIFY_COPY_DELAY:=0}"

echo "$(date): Startup"
echo "$(date): Watching $IN_DIR -> $OUT_DIR (delay=${INOTIFY_COPY_DELAY}s)"

cd "$IN_DIR"

inotifywait -m -e close_write -e moved_to --format '%e|%f' . |
while IFS='|' read -r action file; do
  echo "$(date): event=$action file=$file -> copy in ${INOTIFY_COPY_DELAY}s"

  (
    sleep "$INOTIFY_COPY_DELAY"
    tmp="${file}.part.$$"
    cp -v -- "$IN_DIR/$file" "$OUT_DIR/$tmp" &&
    mv -v -- "$OUT_DIR/$tmp" "$OUT_DIR/$file"
  ) &
done
