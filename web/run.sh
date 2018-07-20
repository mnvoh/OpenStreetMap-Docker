#!/bin/bash

/wait-for-postgres.sh

if [ -f /data/import.osm.pbf ]; then
  osm2pgsql -H postgres -P 5432 -d ${POSTGRES_DB} --username ${POSTGRES_USER} --slim  -G --hstore --tag-transform-script /home/${USERNAME}/openstreetmap-carto/openstreetmap-carto.lua -C ${IMPORT_MEMORY_SIZE} --number-processes ${IMPORT_CPU_COUNT} -S /home/${USERNAME}/openstreetmap-carto/openstreetmap-carto.style -r pbf /data/import.osm.pbf
fi

service apache2 start
su - www-data -c "renderd -f -c /usr/local/etc/renderd.conf" -s /bin/sh
