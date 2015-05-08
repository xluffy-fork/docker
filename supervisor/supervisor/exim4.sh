#!/bin/bash

if [[ "${EXIM4_ENABLE:-0}" == "0" ]]; then
  rm -f /etc/s.supervisor/exim4.s
  exit 0
fi

if [[ "${1:-}" == "start" ]]; then
  exec /usr/sbin/exim4 -v -bdf -q30m
  :
fi

########################################################################
# Configuration generator
########################################################################

_exim4_uid_gid_update() {
  EXIM4_UID="${EXIM4_UID:-10004}"
  EXIM4_GID="${EXIM4_GID:-10004}"
  groupmod -g "$EXIM4_GID" Debian-exim
  usermod -g "$EXIM4_GID" -u "$EXIM4_UID" Debian-exim
  chown Debian-exim:Debian-exim -Rc /var/spool/exim4/
  chown Debian-exim:Debian-exim -Rc /var/log/exim4/
  # FIXME: Exim4 bug here lolz
  chmod 750 /var/log/exim4
  chown root:Debian-exim  /etc/exim4/passwd.client

  # This is to make sure root can read default email
  if [[ ! -f /var/mail/root ]]; then
    ln -vs /var/mail/mail /var/mail/root
  fi
}

_exim4_config_update() {
  local _other_names

  if [[ "${EXIM4_MINE_CONFIG:-0}" != 0 ]]; then
    /usr/sbin/update-exim4.conf
    return
  fi

  if [[ -z "${EXIM4_MAILNAME:-}" ]]; then
    EXIM4_MAILNAME="$(hostname -f)"
  fi
  echo "$EXIM4_MAILNAME" > /etc/mailname

  local _other_names="$EXIM4_MAILNAME"
  for _name in ${EXIM4_OTHER_NAMES:-}; do
    _other_names="$_other_names ; $_name"
  done

  cat \
    > /etc/exim4/update-exim4.conf.conf \
<<EOF
# This file is generated by Docker generator.
# Please do not edit this file.
dc_eximconfig_configtype='internet'
dc_other_hostnames='$_other_names'
dc_local_interfaces='127.0.0.1 ; ::1'
dc_readhost=''
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost=''
CFILEMODE='644'
dc_use_split_config='true'
dc_hide_mailname=''
dc_mailname_in_oh='true'
dc_localdelivery='mail_spool'
EOF

  /usr/sbin/update-exim4.conf
}

########################################################################
# main tasks
########################################################################

_exim4_uid_gid_update
_exim4_config_update

cat \
  > /etc/s.supervisor/exim4.s \
<<EOF
[program:exim4]
command=$0 start
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
user=Debian-exim
redirect_stderr=true
stdout_logfile=/supervisor/exim4.log
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
