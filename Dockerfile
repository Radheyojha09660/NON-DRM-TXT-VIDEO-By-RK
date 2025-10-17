FROM python:3.9-slim-bullseye

# Set noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        gcc \
        libffi-dev \
        musl-dev \
        ffmpeg \
        aria2 \
        python3-pip \
        curl \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy project
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --no-cache-dir -U yt-dlp

# Expose port for Flask web
EXPOSE 8080

# Start both Flask web + bot
CMD ["sh", "-c", "gunicorn web:app -b 0.0.0.0:8080 & python3 main.py"]
