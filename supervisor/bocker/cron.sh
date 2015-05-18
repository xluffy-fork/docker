#!/bin/bash

# Purpose: Bocker library to support Cron in Supervisor
# Author : Anh K. Huynh
# Date   : 2015 May 18th

ed_ship --later \
  ed_cron_daemonize \
  ed_cron_generate_config

ed_cron_daemonize() {
  if [[ "${CRON_ENABLE:-0}" == "0" ]]; then
    rm -f /etc/s.supervisor/cron.s
    exit 0
  fi
  exec /usr/sbin/cron -f -L ${CRON_LOGLEVEL:-1}
}

ed_cron_generate_config() {
  cat \
  > /etc/s.supervisor/cron.s \
<<EOF
[program:cron]
command=/bocker.sh ed_cron_daemonize
process_name=%(program_name)s
numprocs=1
directory=/
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=root
redirect_stderr=true
stdout_logfile=/supervisor/cron.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=10
stdout_capture_maxbytes=0
stdout_events_enabled=false
stderr_logfile=AUTO
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=10
stderr_capture_maxbytes=0
stderr_events_enabled=false
environment=
EOF
}
