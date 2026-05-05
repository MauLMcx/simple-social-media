#!/bin/sh
mkdir -p bootstrap/cache \
         storage/framework/cache \
         storage/framework/sessions \
         storage/framework/views
chown -R www-data:www-data bootstrap storage || true
chmod -R ug+rwx bootstrap storage || true

echo "Memulai instalasi package (Maks 120 detik)..."
timeout 120 npm install --legacy-peer-deps --no-audit --progress=false || true
timeout 60 npm run dev || true
timeout 120 composer install --optimize-autoloader --no-interaction || true

cp .env.example .env || true
php artisan key:generate || true
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.2/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

timeout 30 php artisan migrate --force || true
timeout 30 php artisan db:seed --force || true
