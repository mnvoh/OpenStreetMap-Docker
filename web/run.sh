#!/bin/bash

/home/${USERNAME}/wait-for-postgres.sh postgres ${POSTGRES_USER} ${POSTGRES_PASS}

if [ -f /data/import.osm.pbf ]; then
  osm2pgsql -H postgres -P 5432 -d ${POSTGRES_DB} \
  --username ${POSTGRES_USER} --password ${POSTGRES_PASS} --slim  -G \
  --hstore \
  --tag-transform-script /home/${USERNAME}/openstreetmap-carto/openstreetmap-carto.lua \ 
  -C ${IMPORT_MEMORY_SIZE} --number-processes ${IMPORT_CPU_COUNT} \
  -S /home/${USERNAME}/openstreetmap-carto/openstreetmap-carto.style \
  /data/import.osm.pbf
fi

renderd -c /usr/local/etc/renderd.conf


