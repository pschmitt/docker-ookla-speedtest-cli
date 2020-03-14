#!/usr/bin/env ash
# shellcheck shell=dash

DATA_PATH="${DATA_PATH:-/data/speedtest.json}"
INTERVAL="${INTERVAL:-600}"
HEALTHCHECK_TOLERANCE="${HEALTHCHECK_TOLERANCE:-3}"

usage() {
  echo "$(basename "$0") run|check"
}

run() {
  while true
  do
    if speedtest --accept-license --accept-gdpr -f json | tee /tmp/speedtest.json
    then
      # "Publish" result
      mv /tmp/speedtest.json "$DATA_PATH"
    fi
    sleep "$INTERVAL"
  done
}

healthcheck() {
  local last_speedtest
  local now

  last_speedtest="$(jq '.timestamp | fromdate' "$DATA_PATH")"
  now="$(date '+%s')"

  tdiff=$(( now - last_speedtest ))
  tolerance=$(( HEALTHCHECK_TOLERANCE * INTERVAL ))

  # shellcheck disable=2169
  if [[ "$tdiff" -gt "$tolerance" ]]
  then
    return 1
  fi
}

set -e

case "$1" in
  run)
    run
    ;;
  check|c|healthcheck|--healthcheck|--check|-H)
    healthcheck || exit 1
    ;;
  help|h|--help|-h)
    usage
    exit 0
    ;;
  *)
    usage
    exit 2
    ;;
esac
