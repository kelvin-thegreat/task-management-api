FROM php:8.4-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

# WHERE THE APP RUNS
EXPOSE 8080

# FORCE PORT FALLBACK
ENV PORT=8080

CMD php artisan config:clear && php artisan cache:clear && php artisan serve --host=0.0.0.0 --port=8080