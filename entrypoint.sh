#! /bin/sh

set -e

POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_PORT=5432
POSTGRES_DB=${POSTGRES_DB:-${POSTGRES_ENV_POSTGRES_DB}}
POSTGRES_ADMIN_USER=${POSTGRES_ADMIN_USER:-${POSTGRES_ENV_POSTGRES_USER}}
POSTGRES_ADMIN_PASSWORD=${POSTGRES_ADMIN_PASSWORD:-${POSTGRES_ENV_POSTGRES_PASSWORD}}
POSTGRES_URL="jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"

# Set up database
echo "Waiting to set up database..."
nc="nc ${POSTGRES_HOST} ${POSTGRES_PORT} </dev/null 2>/dev/null"
set +e
eval ${nc}
while [ $? -ne 0 ]; do
  echo ...
  sleep 5
  eval ${nc}
done
set -e
cd flyway/
./flyway migrate -url="${POSTGRES_URL}" -user="${POSTGRES_ADMIN_USER}" -password="${POSTGRES_ADMIN_PASSWORD}" -placeholders.app_user="${POSTGRES_USER}" -placeholders.app_password="${POSTGRES_PASSWORD}"
cd

# Blot out secrets
export POSTGRES_ADMIN_USER=""
export POSTGRES_ADMIN_PASSWORD=""

# Run application
export POSTGRES_HOST
export POSTGRES_PORT
export POSTGRES_DB
node .
