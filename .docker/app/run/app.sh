#!/bin/bash

cd /usr/share/app/

cp .env.example .env
composer install
chmod -Rf 777 storage/
php artisan key:generate
