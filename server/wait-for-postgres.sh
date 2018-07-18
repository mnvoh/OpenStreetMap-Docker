#!/bin/bash
# wait-for-postgres.sh

set -e

host="$1"
user="$2"
PGPASSWORD="$3"
shift

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$host" -U "$user" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
