#!/bin/sh
set -eu
mkdir -p /data storage/app/public storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs
mkdir -p /shared/public
cp -a public/. /shared/public/
if [ ! -s /data/app-key ]; then
    (umask 077; php -r 'echo "base64:".base64_encode(random_bytes(32));' > /data/app-key)
fi
APP_KEY="$(cat /data/app-key)"
export APP_KEY
chown -R www-data:www-data /data storage bootstrap/cache
chmod 600 /data/app-key
php artisan config:clear --no-interaction
php artisan migrate --force --no-interaction
php artisan storage:link --no-interaction
php artisan config:cache --no-interaction
chown -R www-data:www-data bootstrap/cache
exec docker-php-entrypoint "$@"
