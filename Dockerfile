# Mutemo Desk — Docker image for Render (or any container host)
# Includes Python, Node.js, Tesseract OCR, and Poppler in one image.

FROM python:3.11-slim

# ── System dependencies ──────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    poppler-utils \
    antiword \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the docx npm package globally (used for DOCX export)
RUN npm install -g docx

WORKDIR /app

# ── Python dependencies ──────────────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download the embedding model so it's baked into the image
# (avoids a slow/fragile download on first request in production)
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"

# ── Application code ─────────────────────────────────────────────────────────
COPY . .

# Data directory for persistence (mount a volume here on Render)
RUN mkdir -p /app/data

EXPOSE 8000

# Render sets $PORT — bind to it, falling back to 8000 for local docker runs
CMD ["sh", "-c", "cd backend && python main.py"]
