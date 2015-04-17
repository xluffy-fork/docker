## btsync-1.3 buildfile for Docker

`btsync-1.3` is a great software with clean UI and simple idea.

There are now `btsync-1.4`, `btsync-2.0`. They are for professional
users who likes a messy `UI` and dummy stupid function.

We are only novice users.

## Environments

* `BTSYNC_NAME`: the device name
* `BTSYNC_PASSWD`: the password of `admin` account
* `BTSYNC_INTERVAL`: folder scanning interval. Default: 300 seconds

## Volume

* `/home/btsync/`: contains all `btsync` data.

## Usage

When the container is started, it will listen on `8888` (`webui`)
and `8881` (`data`) ports. A random password is generated and written
to the `docker` logs, unless you specify one with `BTSYNC_PASSWD`
environment.

The data volume (`/home/btsync/`) contains all `btsync` variant files
and synchornization folders.