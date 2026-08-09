# 1. Base Image
FROM python:3.12-slim

# 2. Working Directory
WORKDIR /app

# 3. Copy requirements first (for Docker layer caching)
COPY requirements.txt .

# 4. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy application code
COPY . .

# 6. Create a non-root user and switch to it
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser \
    && chown -R appuser:appgroup /app
USER appuser

# 7. Expose port
EXPOSE 5000

# 8. Run Flask via gunicorn (production WSGI server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
