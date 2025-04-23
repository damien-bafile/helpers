# Justfile for Laravel Docker Setup

# ────────────────────────────────
# 🐳 Docker Lifecycle Management
# ────────────────────────────────

# Build all containers
build: 
  docker-compose build

# Start the services in detached mode
up:
  docker-compose up -d

# Stop all running services
down:
  docker-compose down

# Restart all services
restart-all:
  docker-compose restart

# Restart a specific service
restart service:
  docker-compose restart {{service}}

# View running containers
ps:
  docker-compose ps

# Tail logs from all containers
logs:
  docker-compose logs -f

# Tail logs from a specific service
logs-service service:
  docker-compose logs -f {{service}}

# Remove containers, networks, volumes, and images
clean:
  test ! -e src/.env || rm -f src/.env
  test ! -e src/storage || rm -rf src/storage
  docker-compose down --rmi all --volumes --remove-orphans

# Rebuild and restart services from scratch
rebuild:
  docker-compose down --volumes --remove-orphans
  test ! -e src/.env || rm -f src/.env
  test ! -e src/storage || rm -rf src/storage
  docker-compose build
  docker-compose up -d

# Prune Docker system (⚠️ Use with caution)
prune:
  docker system prune -af --volumes

# Show Docker volumes and images
volumes:
  docker volume ls

images:
  docker images

# Restart Docker daemon (requires sudo)
restart-docker:
  sudo systemctl restart docker

# ────────────────────────────────
# ⚙️ Laravel-Specific Commands
# ────────────────────────────────

# Run any artisan command (e.g., just artisan migrate)
artisan *args:
  docker-compose run --rm artisan {{args}}

# Generate Laravel app key
key-generate:
  docker-compose run --rm artisan key:generate

# Clear Laravel caches
clear-cache:
  docker-compose run --rm artisan optimize:clear

# Fresh migration with seed
migrate-fresh:
  docker-compose run --rm artisan cache:forget spatie.permission.cache
  docker-compose run --rm artisan migrate:fresh --seed

# Seed the database
db-seed:
  docker-compose run --rm artisan db:seed

# Run Laravel tests
test *args:
  docker-compose run --rm php ./vendor/bin/phpunit {{args}}

# ────────────────────────────────
# 📦 Dependency & File Management
# ────────────────────────────────

# Run any composer command
composer *args:
  docker-compose run --rm composer {{args}}

# Run any npm command
npm *args:
  docker-compose run --rm npm {{args}}

# npm install
npm-install package="":
    docker-compose exec npm sh -c "npm install {{package}}"

# npm install package --save
npm-save package:
    docker-compose exec npm sh -c "npm install {{package}}"

# npm npm run dev
npm-dev:
    docker-compose exec npm npm run dev

# Reset dependencies (vendor/node_modules) and reinstall
reset-deps:
  rm -rf src/vendor src/node_modules src/package-lock.json src/composer.lock
  docker-compose run --rm composer install
  docker-compose run --rm npm install

# Set permissions for Laravel storage/cache
permissions:
  docker-compose exec php chmod -R 775 storage bootstrap/cache
  docker-compose exec php chown -R www-data:www-data storage bootstrap/cache

# Setup .env from template if it doesn't exist
env-setup:
  test -e src/.env || cp src/.env.example src/.env

# ────────────────────────────────
# 🖥️ Shell Access Helpers
# ────────────────────────────────

# Open a bash shell in the php container
bash-php:
  docker-compose exec php bash

# Open a bash shell in the mysql container
bash-mysql:
  docker-compose exec mysql bash

# Open a bash shell in the webserver container
bash-webserver:
  docker-compose exec webserver bash
