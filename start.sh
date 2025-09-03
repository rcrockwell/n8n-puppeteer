#!/bin/bash

# Set n8n configuration
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_PROTOCOL=http
export N8N_LOG_LEVEL=info
export N8N_USER_FOLDER=/app/.n8n

# Set Puppeteer configuration for headless mode
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
export CHROME_BIN=/usr/bin/google-chrome-stable

# Create n8n directory if it doesn't exist
mkdir -p /app/.n8n

# Start n8n
exec npx n8n start