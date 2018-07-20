#!/usr/bin/env bash

source /env-data.sh

# This script will setup pg_hba.conf

# Reconfigure pg_hba if environment settings changed
cat $ROOT_CONF/pg_hba.conf.template > $ROOT_CONF/pg_hba.conf

# allow all, this really needs to be fixed in a way that the other container
# can securely connect to postgres
sed -i -e 's/md5/trust/g' $ROOT_CONF/pg_hba.conf
sed -i -e 's/peer/trust/g' $ROOT_CONF/pg_hba.conf
