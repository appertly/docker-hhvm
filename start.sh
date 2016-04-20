#!/bin/sh

if [ "$MEMCACHED" != "" ]; then
    sed -i "s/handler = files/handler = memcached/" /etc/hhvm/php.ini
    sed -i "s/\/var\/lib\/hhvm\/sessions/$MEMCACHED/" /etc/hhvm/php.ini
fi

update-ca-certificates

DAEMON=/usr/bin/hhvm
PIDFILE=/var/run/hhvm/pid
CONFIG_FILE="/etc/hhvm/server.ini"
SYSTEM_CONFIG_FILE="/etc/hhvm/php.ini"
RUN_AS_USER="www-data"
RUN_AS_GROUP="www-data"
ADDITIONAL_ARGS=""

DAEMON_ARGS="--config ${SYSTEM_CONFIG_FILE} \
--config ${CONFIG_FILE} \
--user ${RUN_AS_USER} \
--mode server \
${ADDITIONAL_ARGS}"

#
# Function that starts the daemon/service
#
check_run_dir() {
    # Only perform folder creation, if the PIDFILE location was not modified
    PIDFILE_BASEDIR=$(dirname ${PIDFILE})
    # We might have a tmpfs /var/run.
    if [ "/var/run/hhvm" = "${PIDFILE_BASEDIR}" ] && [ ! -d /var/run/hhvm ]; then
        mkdir -p -m0755 /var/run/hhvm
        chown $RUN_AS_USER:$RUN_AS_GROUP /var/run/hhvm
    fi
}

check_run_dir
touch $PIDFILE
chown $RUN_AS_USER:$RUN_AS_GROUP $PIDFILE
exec $DAEMON $DAEMON_ARGS
