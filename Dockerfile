FROM node:16-slim

# Install dependencies for Chromium
RUN apt-get update && apt-get install -y \
  wget \
  ca-certificates \
  fonts-liberation \
  fonts-noto \
  libappindicator3-1 \
  libnss3 \
  libxss1 \
  libasound2 \
  libgbm1 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libxrandr2 \
  libgtk-3-0 \
  libpango-1.0-0 \
  libgdk-pixbuf2.0-0 \
  libnspr4 \
  libxcomposite1 \
  libxdamage1 \
  libxtst6 \
  libvulkan1 \
  chromium \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Set environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Install app dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

# Copy app files
COPY . .

# Start the app
CMD ["node", "index.js"]
