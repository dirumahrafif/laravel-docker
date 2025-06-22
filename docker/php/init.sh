#!/bin/bash

set -e

echo "Hapus default folder html yang sudah ada"
rm -rf /var/www/html

if [ ! -f /var/www/composer.json ]; then
  echo "Laravel belum ada, instalasi dimulai..."
  cd /var/www
  composer create-project laravel/laravel="12.*" .
else
  echo "Laravel sudah terpasang, skip instalasi."
fi

echo "Mengatur hak akses direktori storage dan bootstrap/cache..."
# Buat folder dan file log jika belum ada
mkdir -p /var/www/storage/logs
touch /var/www/storage/logs/laravel.log
# Baru set permission
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

cd /var/www
# Cek mode dari ENV atau default ke 'development'
APP_ENV=${APP_ENV:-development}

echo "Menjalankan optimisasi Laravel..."
composer validate --strict
composer install --optimize-autoloader --no-dev

# Jalankan perintah artisan sesuai environment
if [ "$APP_ENV" = "production" ]; then
    echo "Mode production: menjalankan caching..."
    php artisan config:clear
    php artisan cache:clear
    php artisan view:clear
    php artisan route:clear

    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
else
    echo "Mode development: membersihkan cache..."
    php artisan config:clear
    php artisan cache:clear
    php artisan view:clear
    php artisan route:clear
fi

# Jalankan Apache agar container tetap aktif
exec apache2-foreground

