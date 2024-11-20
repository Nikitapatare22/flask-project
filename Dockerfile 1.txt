# Base Image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy application code
COPY app.py /app

# Install dependencies
RUN pip install --no-cache-dir flask

# Expose the application port
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]
