FROM node:22-bookworm

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    openssh-client \
    curl \
    python3 \
    make \
    g++ \
 && rm -rf /var/lib/apt/lists/*

# Pull latest OpenClaw source
RUN git clone https://github.com/openclaw/openclaw.git /app

WORKDIR /app

# Install dependencies
RUN npm install

# Make openclaw executable
RUN chmod 755 /app/openclaw.mjs

# Create runtime directories
RUN mkdir -p /home/node/.openclaw /home/node/.openclaw/workspace \
 && chown -R node:node /home/node

# Copy entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod 700 /app/entrypoint.sh

ENV NODE_ENV=production

EXPOSE 18789 18790

HEALTHCHECK --interval=3m --timeout=10s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:18789/healthz').then((r)=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["/bin/sh", "/app/entrypoint.sh"]
