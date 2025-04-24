FROM node:18-slim

# Install required dependencies for Chromium
RUN apt-get update && apt-get install -y \
    chromium \
    libxshmfence1 \
    libgbm1 \
    libasound2 \
    fonts-liberation \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgtk-3-0 \
    ca-certificates \
    wget \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .

CMD ["node", "index.js"]
