#!/bin/bash

set -e

NO_CACHE="${1:-}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_PATH="$PROJECT_ROOT/voice_bridge_be"

fail() {
  echo "$1"
  exit 1
}

find_compose_file() {
  for f in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
    if [ -f "$COMPOSE_PATH/$f" ]; then
      return 0
    fi
  done
  return 1
}

wait_for_docker() {
  local start
  start=$(date +%s)

  while true; do
    if docker info >/dev/null 2>&1; then
      echo "Docker is ready."
      return 0
    fi

    now=$(date +%s)
    if [ $((now - start)) -gt 180 ]; then
      fail "ERROR: Docker did not become ready within timeout."
    fi

    sleep 3
  done
}

if ! find_compose_file; then
  fail "ERROR: No Docker Compose file found in $COMPOSE_PATH"
fi

echo "Checking Docker..."
if ! docker info >/dev/null 2>&1; then
  echo "Opening Docker Desktop..."
  open -a Docker || fail "ERROR: Docker Desktop could not be started."
fi

wait_for_docker

echo "Building Docker images..."
cd "$COMPOSE_PATH"

if [ "$NO_CACHE" = "--no-cache" ]; then
  docker compose build --no-cache
else
  docker compose build
fi

echo "Setup completed successfully."