FROM node:18-bullseye

# Install system dependencies for headless Chrome/Puppeteer
# Removed deprecated and unnecessary packages
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    procps \
    libxss1 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libatspi2.0-0 \
    fonts-liberation \
    libappindicator3-1 \
    libatk-bridge2.0-0 \
    libnspr4 \
    lsb-release \
    xdg-utils \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
ENV CHROME_BIN=/usr/bin/google-chrome-stable

# Create non-root user for security
RUN groupadd -r n8nuser && useradd -r -g n8nuser -s /bin/bash n8nuser \
    && mkdir -p /app/.n8n \
    && chown -R n8nuser:n8nuser /app

# Copy start script
COPY start.sh ./
RUN chmod +x start.sh

# Switch to non-root user
USER n8nuser

# Expose n8n port
EXPOSE 5678

# Start the application
CMD ["./start.sh"]