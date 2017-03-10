#!/bin/bash
set -e

cd /opt/broker/

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ./etc/logging.properties

# Update min memory if the argument is passed
if [[ "$ARTEMIS_MIN_MEMORY" ]]; then
    sed -i "s/-Xms512M/-Xms$ARTEMIS_MIN_MEMORY/g" ./etc/artemis.profile
fi

# Update max memory if the argument is passed
if [[ "$ARTEMIS_MAX_MEMORY" ]]; then
    sed -i "s/-Xmx1024M/-Xmx$ARTEMIS_MAX_MEMORY/g" ./etc/artemis.profile
fi

if [ "$1" = 'artemis-server' ]; then
    envsubst < etc/broker.xml > etc/broker_tmp.xml
    mv etc/broker_tmp.xml etc/broker.xml
    exec /opt/broker/bin/artemis run
fi

exec "$@"
