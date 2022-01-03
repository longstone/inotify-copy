# inotify-copy

docker base to copy new files from one location to another


## compose-example

```docker-compose
version: "3.8"
services:
  copy-scan-to-backup:
    image: ghcr.io/longstone/inotify-copy
    container_name: copy-scan-backup
    user: "501:20"
    volumes:
      - /mnt/scan:/in
      - /mnt/backup:/out
    restart: unless-stopped
```
