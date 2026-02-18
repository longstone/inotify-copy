# inotify-copy

Watches an input directory for new or changed files and copies them to an output directory.  
Designed for scenarios where the source device writes files slowly (e.g. network scanners) —
the copy is delayed and debounced so only a complete file is transferred.  
Original files are left untouched.

## Features

- **Checksum stability** — after the initial delay, the file's SHA-1 checksum is compared across intervals. The copy only starts once two consecutive checksums match, guaranteeing the file is fully written.
- **Debounce** — multiple writes to the same file trigger only one copy operation, avoiding redundant work.
- **Atomic copy** — files are written to a temporary name and renamed, so consumers never see a partial file.
- **Lightweight** — Alpine-based image (~9 MB), no runtime dependencies beyond `inotify-tools`.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `IN_DIR` | `/in` | Directory to watch for new / changed files |
| `OUT_DIR` | `/out` | Directory to copy files to |
| `INOTIFY_COPY_DELAY` | `0` | Delay before copying (passed to `sleep`, e.g. `0`, `10`, `15s`) |

## Compose example

```yaml
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

## Running on a Synology NAS

The image works on any Synology NAS that supports **Container Manager** (Docker), which
includes all models with an **x86_64** CPU (the `+` and `xs` series).

Tested / compatible models include the **DS1019+** (Intel Celeron J3455).

### Setup via Container Manager

1. Open **Container Manager** → **Registry** → search for `ghcr.io/longstone/inotify-copy` and download the image.
2. Create a container with the settings above, mapping your scan and backup shared folders to `/in` and `/out`.
3. Set `INOTIFY_COPY_DELAY` to a value that gives your scanner enough time to finish writing (e.g. `15s`).
4. Set the `user` to match the owner of your shared folders (run `id` via SSH to find your UID/GID).

### Setup via SSH

Create a `docker-compose.yml` on the NAS (e.g. in `/volume1/docker/inotify-copy/`):

```yaml
services:
  copy-scan-to-backup:
    image: ghcr.io/longstone/inotify-copy
    container_name: copy-scan-backup
    user: "1026:100"
    environment:
      - INOTIFY_COPY_DELAY=15s
    volumes:
      - /volume1/scan:/in
      - /volume1/backup:/out
    restart: unless-stopped
```

Then start with:

```sh
sudo docker-compose up -d
```
