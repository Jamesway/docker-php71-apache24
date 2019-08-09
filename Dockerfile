FROM php:7.1-apache-stretch


RUN apt-get update && apt-get install -y \
    wget \
    git \
    gnupg

# workaround for postgres https://www.postgresql.org/download/linux/debian/
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update && apt-get install -y \
       libpq-dev \
       postgresql-client-9.6

RUN docker-php-ext-install pdo_pgsql

# change apache root to public, allow .htaccess and enable mod rewrite
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/' /etc/apache2/sites-enabled/000-default.conf \
    && printf '<Directory /var/www/html/public/>\n    Options Indexes FollowSymLinks\n    AllowOverride All\n    Require all granted\n</Directory>' >> /etc/apache2/sites-enabled/000-default.conf \
    && a2enmod rewrite

COPY --from=composer /usr/bin/composer /usr/bin/composer
