#!/usr/bin/env bash
set -eo pipefail

# Default environment
ENV=${1:-dev}

# Validate environment
case $ENV in
    dev|test|prod)
        echo "Starting services in $ENV environment..."
        ;;
    *)
        echo "Invalid environment: $ENV"
        echo "Usage: $0 [dev|test|prod]"
        exit 1
        ;;
esac

# Load environment variables
if [ -f ".env.${ENV}" ]; then
    export $(cat .env.${ENV} | grep -v '^#' | xargs)
else
    echo "Environment file .env.${ENV} not found!"
    exit 1
fi

# Start services
if [ "$ENV" = "prod" ]; then
    docker-compose --env-file .env.${ENV} up -d --build --remove-orphans
else
    docker-compose --env-file .env.${ENV} up --build
fi 