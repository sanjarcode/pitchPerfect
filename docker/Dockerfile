# docker/Dockerfile
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libssl-dev \
    wget \
    tesseract-ocr \
    libtesseract-dev \
    libgl1 \
    adb \
    && rm -rf /var/lib/apt/lists/*

# Make work directoy
WORKDIR /app
COPY app/requirements.txt requirements.txt

COPY .env .env

# Install compatible numpy and other dependencies from requirements.txt
RUN pip install --no-cache-dir numpy==1.21.6
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ /app/

# Download spaCy English model
RUN python -m spacy download en_core_web_sm

EXPOSE 8000

CMD ["bash", "-c", "adb start-server && python main.py"]