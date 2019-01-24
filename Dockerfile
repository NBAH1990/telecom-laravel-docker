FROM php:alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    libzip \
    libzip-dev \
    php-soap \
    libsodium-dev

# Install production dependencies
RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    nodejs \
    nodejs-npm \
    openssh-client \
    rsync \
    unzip \
    libzip \
    libzip-dev \
    php-soap \
    libsodium-dev

# Install PECL and PEAR extensions test
RUN pecl install \
    imagick \
    zip \
    mongodb

#RUN pear install PHP_CodeSniffer
# Install and enable php extensions
RUN docker-php-ext-enable \
    imagick \
    zip \
    mongodb

RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath \
    soap \
    sodium \
    exif

# Install composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="./vendor/bin:$PATH"

# Install composer parallel
RUN composer global require hirak/prestissimo

# Install deployer
RUN curl -LsO https://deployer.org/deployer.phar \
    && mv deployer.phar /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep

# Cleanup dev dependencies
RUN apk del -f .build-deps

# Setup working directory
WORKDIR /var/www
