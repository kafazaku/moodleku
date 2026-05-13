# Moodle 5.2 Docker Image

FROM php:8.3-fpm-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libpq-dev \
    postgresql-client \
    mysql-client \
    graphviz \
    aspell \
    ghostscript \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    curl \
    zip \
    xml \
    mbstring \
    intl \
    soap \
    opcache \
    && docker-php-ext-enable \
    gd \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    curl \
    zip \
    xml \
    mbstring \
    intl \
    soap \
    opcache

# Install sodium extension
RUN apt-get update && apt-get install -y libsodium-dev && \
    docker-php-ext-install sodium && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/moodle

# Download Moodle
RUN wget -q https://download.moodle.org/download.php/direct/stable42/moodle-5.2.tgz && \
    tar -xzf moodle-5.2.tgz && \
    rm moodle-5.2.tgz && \
    mv moodle/* . && \
    rmdir moodle

# Create moodledata directory structure
RUN mkdir -p /var/moodledata && \
    chmod 777 /var/moodledata

# Copy PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/moodle.ini

# Set PHP-FPM user
ENV PHP_USER=www-data

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Wait for database\n\
echo "Waiting for database..."\n\
while ! nc -z ${DB_HOST:-moodle-db} ${DB_PORT:-3306}; do\n\
  sleep 1\n\
done\n\
echo "Database is up"\n\
\n\
# Create config.php if it does not exist\n\
if [ ! -f /var/www/moodle/config.php ]; then\n\
  echo "Creating config.php..."\n\
  cp /config.php /var/www/moodle/config.php\n\
fi\n\
\n\
# Start PHP-FPM\n\
php-fpm\n\
' > /start.sh && chmod +x /start.sh

# Copy config template
COPY config.php /config.php

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:9000/ping || exit 1

# Expose port
EXPOSE 9000

# Start PHP-FPM
CMD ["/start.sh"]
