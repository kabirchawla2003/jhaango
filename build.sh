#!/bin/bash

# Exit immediately if any command exits with a non-zero status.
set -e

# Check if the build has already been run.
if [ -f ".build_complete" ]; then
    echo "Build already completed. Exiting."
    exit 0
fi

echo "Starting initial build..."

# Optionally, copy .env.example to .env if .env doesn't exist.
if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    cp .env.example .env
    echo "Copied .env.example to .env"
fi

# Create a virtual environment if it doesn't exist.
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the virtual environment.
source venv/bin/activate

# Upgrade pip (optional but recommended).
pip install --upgrade pip

# Install Python dependencies.
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
else
    echo "requirements.txt not found. Exiting."
    exit 1
fi

# Apply Django migrations.
echo "Running Django migrations..."
python manage.py makemigrations
python manage.py migrate

# Collect static files (if applicable).
echo "Collecting static files..."
python manage.py collectstatic --noinput

# (Optional) Create a superuser non-interactively.
# Uncomment and modify the following lines if you want to create a superuser automatically.
# echo "Creating superuser..."
# python manage.py shell <<EOF
# from django.contrib.auth import get_user_model;
# User = get_user_model();
# User.objects.create_superuser('admin', 'admin@example.com', 'adminpassword')
# EOF

# Mark the build as complete.
touch .build_complete
echo "Initial build complete."
