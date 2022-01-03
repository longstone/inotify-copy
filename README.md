# inotify-copy

copy files from input to output directory.
Leave original files untouched.

## config

INOTIFY_COPY_DELAY = a delay (`sleep`) before the copy starts.

## compose-example

```docker-compose
version: "3.8"
services:
  copy-scan-to-backup:
    image: ghcr.io/longstone/inotify-copy
    container_name: copy-scan-backup
        user: "${USR}:${GRP}"
    environment:
      - INOTIFY_COPY_DELAY=10s
    volumes:
      - /mnt/scan:/in
      - /mnt/backup:/out
    restart: unless-stopped
```