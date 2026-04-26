FROM node:24

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash appuser && \
    echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /app && \
    chown appuser:appuser /app

RUN npm install -g corepack && \
    corepack enable

WORKDIR /app
USER appuser
COPY --chown=appuser:appuser package.json pnpm-lock.yaml .
RUN pnpm install --frozen-lockfile --production && \
    pnpm exec playwright install --with-deps chromium && \
    pnpm cache delete

COPY --chown=appuser:appuser index.ts .

CMD ["node", "index.ts"]
