#!/bin/sh
set -eu

OPENCLAW_HOME="/home/node/.openclaw"
OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"

mkdir -p "$OPENCLAW_HOME" "$OPENCLAW_HOME/workspace"

if [ -n "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then
  node /app/openclaw.mjs config set gateway.auth.token "$OPENCLAW_GATEWAY_TOKEN"
fi

if [ -n "${OPENCLAW_GATEWAY_CONTROL_UI_ALLOWED_ORIGINS:-}" ]; then
  node /app/openclaw.mjs config set gateway.controlUi.allowedOrigins "[\"$OPENCLAW_GATEWAY_CONTROL_UI_ALLOWED_ORIGINS\"]"
fi

if [ -n "${OPENCLAW_GATEWAY_TRUSTED_PROXIES:-}" ]; then
  node /app/openclaw.mjs config set gateway.trustedProxies "[\"$OPENCLAW_GATEWAY_TRUSTED_PROXIES\"]"
fi

exec node /app/openclaw.mjs gateway --bind "${OPENCLAW_GATEWAY_BIND:-lan}" --port "${OPENCLAW_GATEWAY_PORT}" --allow-unconfigured
