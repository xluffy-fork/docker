#!/bin/bash

_HOSTNAME="${BTSYNC_NAME:-$HOSTNAME}"
_INTERVAL="${BTSYNC_INTERVAL:-300}"
_PASSWD="${BTSYNC_PASSWD:-$RANDOM$RANDOM}"

cat > /home/btsync/var/btsync.conf <<EOF
//
// This file is generated. Do not edit this file manually
//
{
  "device_name": "$_HOSTNAME",
  "listening_port" : 8889,
  "storage_path" : "/home/btsync/var/",
  "folder_rescan_interval": $_INTERVAL,

  "check_for_updates" : false,
  "use_upnp" : false,
  "download_limit" : 0,
  "upload_limit" : 0,

  "webui" :
  {
    "directory_root" : "/home/btsync/sync/",
    "listen" : "0.0.0.0:8888",
    "login" : "admin",
    "password" : "$_PASSWD"
  }
}
EOF

echo >&2 ":: btsync admin password: $_PASSWD"

exec /usr/bin/btsync --config /home/btsync/var/btsync.conf --nodaemon
