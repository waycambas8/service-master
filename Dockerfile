FROM php:8.1-fpm

RUN apt-get update && apt-get install -y git \
    gcc \
    g++ \
    make autoconf

RUN apt-get install -y \
    pkg-config \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    unzip \
    libxml2-dev \
    libmemcached-dev \
    libmemcached11 \
    build-essential \
    libmcrypt-dev \
    libreadline-dev \
    openssl \
    libcurl4-openssl-dev \
    libssl-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) gd

# Install additional PHP extensions
RUN apt-get install -y libzip-dev zlib1g-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install dom \
    && docker-php-ext-install session

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN chmod +rx /usr/local/bin/composer

# Permission
RUN usermod -a -G www-data root
RUN chown -R www-data:www-data ./

# Install Nginx and Supervisor
RUN apt-get update && apt-get install -y nginx supervisor

# Copy Nginx configuration
COPY .docker/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .docker/etc/nginx/servers/app.conf /etc/nginx/servers/default.conf

COPY . /usr/share/app
COPY .docker/app /app
RUN chmod -R +rx /app

COPY .docker/etc/supervisord /etc/supervisord.d/

EXPOSE 9000 9001 443 80

WORKDIR /usr/share/app

CMD ["/app/run.sh"]

