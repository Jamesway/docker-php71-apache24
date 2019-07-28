FROM php:7.1-apache-stretch

RUN apt-get update && apt-get install -y \
	mcrypt

COPY --from=composer /usr/bin/composer /usr/bin/composer
