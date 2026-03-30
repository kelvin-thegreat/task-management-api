FROM php:8.4-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

# IMPORTANT: expose correct port
EXPOSE 8080

# Laravel public entry
CMD php -S 0.0.0.0:8080 -t public public/index.php