FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Aktifkan mod_rewrite untuk Laravel
RUN a2enmod rewrite

# Salin konfigurasi Apache
COPY docker/php/apache.conf /etc/apache2/sites-available/000-default.conf

# salin entrypoint
COPY docker/php/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh
ENTRYPOINT ["/usr/local/bin/init.sh"]
