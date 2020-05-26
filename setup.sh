#!/bin/sh

mkdir uploads && chown -R 911:911 uploads

docker-compose up -d postgres
docker exec -i pleroma_postgres psql -U pleroma -c "CREATE EXTENSION IF NOT EXISTS citext;"
docker-compose down

docker-compose build

docker-compose run --rm web mix ecto.migrate
