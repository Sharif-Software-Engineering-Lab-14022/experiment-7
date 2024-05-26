#!/bin/sh

# Wait for the database to be ready
./wait-for-it.sh db:5432 -- echo "Database is up"

# Run migrations
python manage.py makemigrations
python manage.py migrate

# Start the Django server
exec "$@"
