#!/usr/bin/env bash

set -euo pipefail
mkdir -p "$HOME"/.local/docker/postgresql
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=local -d -p 5432:5432 -e PGDATA=/var/lib/postgresql/data/pgdata -v "$HOME"/.local/docker/postgresql/data:/var/lib/postgresql/data postgres

docker cp parking_violation.csv  pg-docker:/tmp/parking_violation.csv
docker cp film_permit.csv  pg-docker:/tmp/film_permit.csv
docker cp nyc_zip_codes.csv  pg-docker:/tmp/nyc_zip_codes.csv

docker exec -it pg-docker /bin/bash
psql -d local postgres
