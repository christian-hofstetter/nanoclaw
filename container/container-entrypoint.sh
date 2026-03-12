#!/bin/bash
set -e

# Compile TypeScript only if source has changed since last compile.
# Hash is stored in /tmp/dist/.src-hash (on host-mounted volume, persists across runs).
SRC_HASH=$(find /app/src -name "*.ts" | sort | xargs md5sum 2>/dev/null | md5sum | cut -d' ' -f1)
HASH_FILE="/tmp/dist/.src-hash"

if [ ! -f "/tmp/dist/index.js" ] || [ ! -f "$HASH_FILE" ] || [ "$(cat $HASH_FILE 2>/dev/null)" != "$SRC_HASH" ]; then
  cd /app && npx tsc --outDir /tmp/dist 2>&1 >&2
  ln -sf /app/node_modules /tmp/dist/node_modules
  echo "$SRC_HASH" > "$HASH_FILE"
fi

node /tmp/dist/index.js
