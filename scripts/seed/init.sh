#!/usr/bin/env bash
set -eo pipefail

echo "Initializing seed data..."

# Load environment variables
source ../../deployments/.env

# Seed database
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f ./database/seed.sql

# Seed documents
./documents/copy_samples.sh

echo "Seed data initialization complete!" 