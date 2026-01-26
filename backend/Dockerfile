# ========================
# Stage 1: Builder
# ========================
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

COPY backend/requirements.txt /app/requirements.txt

RUN pip install --upgrade pip && pip install --prefix=/install -r requirements.txt


# ========================
# Stage 2: Runtime
# ========================
FROM python:3.10-slim

WORKDIR /app

# Create non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy project files
COPY backend/ /app/

# Change ownership
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8000

ENV PYTHONUNBUFFERED=1
ENV DEBUG=False

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
