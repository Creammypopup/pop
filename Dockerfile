FROM php:8.2-apache

# ติดตั้ง extension ที่ Laravel ต้องใช้
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev zip curl libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# ติดตั้ง Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# คัดลอกโปรเจกต์ Laravel ไปยังโฟลเดอร์เว็บ
COPY . /var/www/html

WORKDIR /var/www/html

# ติดตั้ง Laravel + migrate
RUN composer install --no-interaction && \
    php artisan key:generate && \
    php artisan migrate --force || true && \
    php artisan db:seed || true

# เปิดพอร์ตให้ Apache
EXPOSE 80
