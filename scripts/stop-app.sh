#!/bin/bash

set -e

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

if ! find_compose_file; then
  fail "ERROR: No Docker Compose file found in $COMPOSE_PATH"
fi

echo "Stopping application containers..."
cd "$COMPOSE_PATH"
docker compose down
echo "Application stopped successfully."