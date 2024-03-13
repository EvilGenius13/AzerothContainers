#!/bin/bash

cd "$(dirname "$0")/.."

docker-compose -p dev-build build app

docker tag "dev-build_app" "evilgenius13/azerothcontainers:latest"

docker push "evilgenius13/azerothcontainers:latest"