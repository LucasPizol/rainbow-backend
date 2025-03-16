#!/bin/bash
set -e

echo "=== BUNDLING ==="
bundle install --jobs 20 --retry 5 --binstubs="$BUNDLE_BIN"

COMMAND="$1"

case "$COMMAND" in
  setup)
    ./bin/database_setup.sh
    ;;
  server)
    rm -f /rnb/tmp/pids/server.pid
    bundle exec rails server -b 0.0.0.0
    ;;
  sidekiq)
    echo "=== RUNNING SIDEKIQ ==="
    sidekiq -C config/sidekiq.yml
    ;;
  *)
    echo "=== RUNNING COMAND -> $* ==="
    sh -c "$*"
    ;;
esac
