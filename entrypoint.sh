#!/usr/bin/env ash

chown -R speedtest /data

exec su speedtest -c "/cron.sh run"
