#!/usr/bin/env bash
set -eo pipefail

# Colors for output
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

# Default environment
ENV=${1:-dev}

echo -e "${YELLOW}Loading seed data for ${ENV} environment...${NC}"

# Load environment variables
if [ -f ".env.${ENV}" ]; then
    export $(cat .env.${ENV} | grep -v '^#' | xargs)
else
    echo -e "${RED}Environment file .env.${ENV} not found!${NC}"
    exit 1
fi

# Run seeder service
docker-compose --env-file .env.${ENV} run --rm seeder

echo -e "${GREEN}Seed data loaded successfully!${NC}" 