#!/bin/bash

# Create runtime directories
mkdir -p /dev/shm/gunicorn
chmod 777 /dev/shm/gunicorn

# Create sheets_config directory and credentials file
mkdir -p sheets_config
echo "$GOOGLE_SHEETS_CREDENTIALS" > sheets_config/credentials.json
chmod 644 sheets_config/credentials.json

# Set environment variables for Gunicorn
export GUNICORN_CMD_ARGS="--config=gunicorn.conf.py"
export PYTHONUNBUFFERED=1
export PYTHONPATH="${PYTHONPATH}:/tmp/*/antenv/lib/python3.11/site-packages"

# Start Gunicorn with proper signal handling
exec gunicorn main:app \
    --preload \
    --worker-tmp-dir /dev/shm/gunicorn \
    --worker-class uvicorn.workers.UvicornWorker \
    --workers 2 \
    --bind 0.0.0.0:8000 