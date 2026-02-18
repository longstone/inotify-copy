# Testing

## Prerequisites

Build the image from the project root:

```sh
make build
```

## Quick test

```sh
docker-compose up          # start the watcher container
sh create-testfiles.sh     # in a second terminal — creates files and compares checksums
```

## Slow-write test

Simulates a device that writes a ~10 MB file over ~2 minutes (120 chunks, 1 s apart).
Verifies that the debounced copy produces an identical file.

```sh
docker-compose up          # start the watcher container
sh slow-write-test.sh      # in a second terminal
```

The script writes chunks via `docker exec` (inotify does not work on macOS Docker volume mounts),
waits for the copy delay + margin, then compares SHA-1 checksums.

## Environment

The `.env` file sets the container user/group. Adjust to match your local UID/GID if needed.