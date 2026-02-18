#!/bin/sh
set -eu

IN_DIR="${IN_DIR:-/in}"
OUT_DIR="${OUT_DIR:-/out}"
: "${INOTIFY_COPY_DELAY:=0}"
LOCK_DIR="/tmp/inotify-copy-locks"
mkdir -p "$LOCK_DIR"

echo "$(date): Startup"
echo "$(date): Watching $IN_DIR -> $OUT_DIR (delay=${INOTIFY_COPY_DELAY})"

cd "$IN_DIR"

inotifywait -m -e close_write -e moved_to --format '%e|%f' . |
while IFS='|' read -r action file; do
  lock="$LOCK_DIR/$file"

  if [ -f "$lock" ]; then
    echo "$(date): event=$action file=$file -> debounced (copy already pending)"
    continue
  fi

  echo "$(date): event=$action file=$file -> copy in ${INOTIFY_COPY_DELAY}"

  touch "$lock"
  (
    sleep "$INOTIFY_COPY_DELAY"
    prev=""
    while true; do
      curr="$(sha1sum "$IN_DIR/$file" | awk '{print $1}')"
      if [ "$curr" = "$prev" ]; then
        break
      fi
      echo "$(date): file=$file checksum=$curr -> file still changing, waiting ${INOTIFY_COPY_DELAY}"
      prev="$curr"
      sleep "$INOTIFY_COPY_DELAY"
    done
    echo "$(date): file=$file checksum=$curr -> stable, copying"
    tmp="$(mktemp "$OUT_DIR/${file}.part.XXXXXX")"
    trap 'rm -f "$tmp" "$lock"' EXIT
    cp -v -- "$IN_DIR/$file" "$tmp" &&
    mv -v -- "$tmp" "$OUT_DIR/$file"
    rm -f "$lock"
  ) &
done
