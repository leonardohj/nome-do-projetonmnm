# =========================
# Dockerfile: PHP + Laravel + PostgreSQL + Vite + TailwindCSS
# =========================

# Base PHP 8.3
FROM php:8.3.10

# Instala dependências do sistema + extensões PHP para PostgreSQL
RUN apt-get update -y && apt-get install -y \
    openssl \
    zip \
    unzip \
    git \
    curl \
    nodejs \
    npm \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define diretório da aplicação
WORKDIR /app

# Copia código da aplicação
COPY . /app

# Instala dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Instala dependências Node e build frontend (Vite + TailwindCSS)
RUN npm install
RUN npm run build

# Ajusta permissões (opcional, dependendo do host)
RUN chown -R www-data:www-data /app \
    && chmod -R 755 /app

# Expõe porta
EXPOSE 8000

# Comando padrão para rodar a aplicação
CMD php artisan serve --host=0.0.0.0 --port=8000