## Supervisor Buildfile for Docker

`Docker` containers naturally contains only one process.
Sometimes, that's good enough. Sometimes, you get a head-ache
with process mangling ([MAKE SURE YOU READ THIS][1]).

So we will run a container that run multiple processed inside.

The container will have `cron` and `exim4` daemon disabled by default.

There is also a mininum `syslog` implementation by `gryphius` on `Github`.
You may need this to get, e.g, all `cron` information and there isn't
`rsyslog`, `syslog-ng` daemon listening.

## Environments

### Core feature

* `SUPERVISOR_LOG_LEVEL`: Logging level. Default: `info`.
* `FOOBAR_UID=<NUMBER>`: User to create / modify.
* `FOOBAR_GID=<NUMBER>`: Group to create / modify.

### Msyslog feature

* `MSYSLOG_ENABLE`: Enable the mininum `syslog` implementation. Default: `0`.

### Cron feature

`cron` is disabled by default. When being enabled, `cron` daemon
writes all to `/dev/log`, hence you need `MSYSLOG_ENABLE=1` to see
`cron` verbose information.

* `CRON_ENABLE`: Enable cron daemon. Default: 0
* `CRON_LOGLEVEL`: Cron debugging level. Default: `1`.

### Exim4 feature

* `EXIM4_ENABLE`: Enable Exim4 daemon. Default: 0
* `EXIM4_UID`: The `uid` of `Debian-exim` account. Default: `10004`.
* `EXIM4_GID`: The `gid` of `Debian-exim` account. Default: `10004`.
* `EXIM4_MAILNAME`: The mail name (See `/etc/mailname`). Default: `$HOSTNAME.`
* `EXIM4_OTHER_NAMES`: Other local names (white space list). Default: empty.
* `EXIM4_MINE_CONFIG`: Use your own config mounted on `/etc/mailname`
      and `/etc/exim4/*`. Default: `0`.

## Generators

Before starting the main daemon, the script `/supervisor.sh` will
execute every `*.sh` found under `/etc/s.supervisor/` directory.
The purpose is to create a dynamic configuration for `supervisor`.

## Note

To avoid long typing, a symbolic link `/usr/bin/s` is created
for `/usr/bin/supervisorctl`. Now you can type, e.g, `s status`.

[1]: http://web.archive.org/web/20150424090620/https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/