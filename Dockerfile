# syntax=docker/dockerfile:1
FROM php:8.4-fpm-bookworm AS php-base
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl unzip libonig-dev libxml2-dev default-libmysqlclient-dev \
    && docker-php-ext-install -j"$(nproc)" mbstring dom pdo_mysql \
    && rm -rf /var/lib/apt/lists/*
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
WORKDIR /var/www/html

FROM php-base AS dependencies
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist
COPY . .
RUN composer dump-autoload --no-dev --optimize --no-interaction

FROM node:24-bookworm-slim AS node
FROM dependencies AS assets
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
ENV VITE_APP_NAME="Boilerplate"
RUN npm ci && npm run build

FROM php-base AS runtime
COPY --from=dependencies /var/www/html /var/www/html
COPY --from=assets /var/www/html/public /var/www/html/public
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/boilerplate-entrypoint
RUN mkdir -p /data /shared/public storage/framework/cache/data storage/framework/sessions storage/framework/views \
    && chown -R www-data:www-data /data storage bootstrap/cache
ENTRYPOINT ["boilerplate-entrypoint"]
CMD ["php-fpm", "-F"]
