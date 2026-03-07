#!/bin/sh
set -eu

OPENCLAW_HOME="/home/node/.openclaw"

mkdir -p "$OPENCLAW_HOME" "$OPENCLAW_HOME/workspace"
chown -R node:node "$OPENCLAW_HOME"

if [ -n "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then
  su -s /bin/sh node -c "node /app/openclaw.mjs config set gateway.token \"$OPENCLAW_GATEWAY_TOKEN\""
fi

exec su -s /bin/sh node -c "exec node /app/openclaw.mjs gateway --bind ${OPENCLAW_GATEWAY_BIND:-lan} --port 18789 --allow-unconfigured"
