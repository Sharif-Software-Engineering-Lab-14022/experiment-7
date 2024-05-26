FROM python:3

ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy the entrypoint script
COPY entrypoint.sh /code/entrypoint.sh
COPY wait-for-it.sh /code/wait-for-it.sh

# Ensure the entrypoint script is executable
RUN chmod +x /app/entrypoint.sh /app/wait-for-it.sh

# Set the entrypoint
ENTRYPOINT ["/code/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]