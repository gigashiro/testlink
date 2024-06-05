FROM php:8.3.4-apache

RUN docker-php-ext-install mysqli

WORKDIR /var/www/html

COPY . .

RUN chown www-data:www-data -R /var/www/html
