#!/bin/bash

set -e

FRONTEND_URL="http://127.0.0.1:3000"
DOCKER_TIMEOUT=180
FRONTEND_TIMEOUT=180

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_PATH="$PROJECT_ROOT/voice_bridge_be"

write_info() {
  echo "$1"
}

write_success() {
  echo "$1"
}

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
      write_success "Docker is ready."
      return 0
    fi

    now=$(date +%s)
    if [ $((now - start)) -gt "$DOCKER_TIMEOUT" ]; then
      fail "ERROR: Docker did not become ready within timeout."
    fi

    sleep 3
  done
}

wait_for_url() {
  local start
  start=$(date +%s)

  while true; do
    if curl -fsS "$FRONTEND_URL" >/dev/null 2>&1; then
      write_success "Frontend is reachable: $FRONTEND_URL"
      return 0
    fi

    now=$(date +%s)
    if [ $((now - start)) -gt "$FRONTEND_TIMEOUT" ]; then
      fail "ERROR: Frontend did not become reachable within timeout: $FRONTEND_URL"
    fi

    sleep 2
  done
}

if ! find_compose_file; then
  fail "ERROR: No Docker Compose file found in $COMPOSE_PATH"
fi

write_info "Checking Docker..."
if ! docker info >/dev/null 2>&1; then
  write_info "Opening Docker Desktop..."
  open -a Docker || fail "ERROR: Docker Desktop could not be started."
fi

wait_for_docker

write_info "Starting application containers..."
cd "$COMPOSE_PATH"
docker compose up -d

wait_for_url

write_info "Opening browser..."
open "$FRONTEND_URL"

write_success "Application started successfully."