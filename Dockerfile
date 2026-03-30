FROM php:8.3-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Run Laravel (IMPORTANT: use Railway PORT)
CMD php artisan serve --host=0.0.0.0 --port=$PORT