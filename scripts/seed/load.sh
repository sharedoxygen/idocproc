#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

# Load environment variables
if [ -f "$PROJECT_ROOT/deployments/.env" ]; then
    source "$PROJECT_ROOT/deployments/.env"
else
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

# Check if running in Docker environment
IN_DOCKER=0
if [ -f "/.dockerenv" ]; then
    IN_DOCKER=1
fi

# Function to wait for database
wait_for_db() {
    echo -e "${YELLOW}Waiting for database...${NC}"
    for i in {1..30}; do
        if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c '\q' >/dev/null 2>&1; then
            echo -e "${GREEN}Database is ready!${NC}"
            return 0
        fi
        sleep 1
    done
    echo -e "${RED}Database connection timeout${NC}"
    return 1
}

# Load database seeds
load_db_seeds() {
    echo -e "${YELLOW}Loading database seeds...${NC}"
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f "$SCRIPT_DIR/database/seed.sql"
    echo -e "${GREEN}Database seeds loaded successfully!${NC}"
}

# Generate sample documents
generate_sample_docs() {
    echo -e "${YELLOW}Generating sample documents...${NC}"
    bash "$SCRIPT_DIR/documents/copy_samples.sh"
    echo -e "${GREEN}Sample documents generated successfully!${NC}"
}

# Main execution
main() {
    # Wait for database if in Docker
    if [ $IN_DOCKER -eq 1 ]; then
        wait_for_db
    fi

    # Create required directories
    mkdir -p "$PROJECT_ROOT/data/sample_documents"

    # Load seeds
    load_db_seeds
    generate_sample_docs

    echo -e "${GREEN}All seed data loaded successfully!${NC}"
}

main 