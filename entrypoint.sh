#!/usr/bin/env ash

INTERVAL="${INTERVAL:-600}"

chown -R speedtest /data

while true
do
  su speedtest -c "speedtest --accept-license --accept-gdpr -f json | tee /tmp/speedtest.json && mv /tmp/speedtest.json /data"
  sleep "$INTERVAL"
done
