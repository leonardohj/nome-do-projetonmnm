#!/bin/sh

echo "Installing PHP dependencies..."
composer install --no-dev --optimize-autoloader

echo "Installing Node dependencies..."
npm install

echo "Installing TailwindCSS + PostCSS if missing..."
npx tailwindcss init -p || echo "Tailwind config already exists"

echo "Building assets..."
npm run build

echo "Caching Laravel config/routes..."
php artisan config:cache
php artisan route:cache

echo "Running migrations..."
php artisan migrate --force

echo "Deploy finished!"