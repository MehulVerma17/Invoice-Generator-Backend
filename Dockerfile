# Use Node base image
FROM node:18-slim

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages for html-pdf-node (Puppeteer dependencies)
RUN apt-get update && apt-get install -y \
    libxshmfence1 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    xdg-utils \
    wget \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]
