#!/usr/bin/env bash
set -eo pipefail

# Configuration
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
LOG_DIR="${PROJECT_ROOT}/build_logs"
ENVIRONMENT=${ENVIRONMENT:-dev}

# Colors and symbols
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
CHECK="${GREEN}✓${NC}"; FAIL="${RED}✗${NC}"

# Track build status using files instead of associative arrays
STATUS_DIR="${LOG_DIR}/status"
declare -i failed_builds=0

# Cleanup function
cleanup() {
    local exit_code=$?
    # Deactivate any active virtual environment
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate 2>/dev/null || true
    fi
    exit $exit_code
}

trap cleanup EXIT

# Initialize build environment
init_build() {
    echo -e "${BLUE}▶ Initializing build environment...${NC}"
    mkdir -p "${LOG_DIR}/progress" "${STATUS_DIR}"
    
    # Create seed data directories
    mkdir -p "${PROJECT_ROOT}/data/sample_documents"
    
    # Load seed data if in development
    if [ "$ENVIRONMENT" = "dev" ]; then
        (cd "${PROJECT_ROOT}/services" && ./seed.sh dev)
    fi
    
    # Create required directories if they don't exist
    for dir in backend frontend services deployments tests; do
        mkdir -p "${PROJECT_ROOT}/${dir}"
        echo "pending" > "${STATUS_DIR}/${dir}"
    done
    
    mkdir -p "${PROJECT_ROOT}/backend/app"
    mkdir -p "${PROJECT_ROOT}/backend/tests"
    
    rm -rf "${LOG_DIR}"/*
    mkdir -p "${STATUS_DIR}"
    
    # Initialize npm in frontend if package.json doesn't exist
    if [ ! -f "${PROJECT_ROOT}/frontend/package.json" ]; then
        (cd "${PROJECT_ROOT}/frontend" && npm init -y)
    fi
    
    # Ensure frontend directory structure exists
    mkdir -p "${PROJECT_ROOT}/frontend/src/pages"
    mkdir -p "${PROJECT_ROOT}/frontend/src/components"
}

# Error handling
handle_error() {
    local component=$1
    echo -e "${FAIL} ${RED}Build failed in ${component}${NC}" | tee -a "${LOG_DIR}/${component}.log"
    echo -e "${YELLOW}Check ${LOG_DIR}/${component}.log for details${NC}"
    echo "failed" > "${STATUS_DIR}/${component}"
    ((failed_builds++))
    return 1
}

# Get component status
get_status() {
    local component=$1
    cat "${STATUS_DIR}/${component}" 2>/dev/null || echo "pending"
}

# Progress meter
progress_meter() {
    local component=$1
    local progress=$2
    local total_width=50
    local filled=$((progress * total_width / 100))
    local empty=$((total_width - filled))
    local bar=$(printf "%${filled}s" | tr ' ' '█')
    bar+=$(printf "%${empty}s" | tr ' ' '░')
    echo -ne "${component}: [${bar}] ${progress}%\r"
}

# Production checks
validate_production() {
    if [ "$ENVIRONMENT" = "prod" ]; then
        echo -e "${BLUE}▶ Validating production settings...${NC}"
        
        # Check for minimum password length
        if [ "${#DB_PASSWORD}" -lt 12 ]; then
            echo -e "${FAIL} Production password must be at least 12 characters"
            exit 1
        fi
        
        # Enforce SSL
        if [ "$DB_SSL" != "true" ]; then
            echo -e "${FAIL} SSL must be enabled in production"
            exit 1
        fi
    fi
}

# Build components
build_component() {
    local component=$1
    local dependencies=$2
    
    # Initialize build status
    echo "running" > "${STATUS_DIR}/${component}"
    
    echo -e "${BLUE}▶ Building ${component}...${NC}"
    
    # Wait for dependencies
    for dep in $dependencies; do
        echo -e "${YELLOW}  ⏳ Waiting for ${dep}...${NC}"
        while [ "$(get_status $dep)" = "running" ]; do
            sleep 1
        done
        if [ "$(get_status $dep)" = "failed" ]; then
            echo -e "${FAIL} Dependency ${dep} failed to build"
            echo "failed" > "${STATUS_DIR}/${component}"
            return 1
        fi
    done
    
    # Run build steps
    case $component in
        backend)
            cd "${PROJECT_ROOT}/backend"
            # Create virtual environment if it doesn't exist
            if [ ! -d "venv" ]; then
                python3 -m venv venv
            fi
            # Activate virtual environment
            source venv/bin/activate || {
                echo -e "${FAIL} Failed to activate virtual environment" | tee -a "${LOG_DIR}/backend.log"
                echo "failed" > "${STATUS_DIR}/${component}"
                return 1
            }
            
            # Ensure pip is up to date
            python -m pip install --upgrade pip >> "${LOG_DIR}/backend.log" 2>&1 || handle_error "backend"
            
            # Install dependencies
            pip install -r requirements.txt >> "${LOG_DIR}/backend.log" 2>&1 || handle_error "backend"
            progress_meter "backend" 50
            
            # Install test dependencies
            pip install pytest fastapi[testing] >> "${LOG_DIR}/backend.log" 2>&1 || handle_error "backend"
            
            # Run tests if they exist
            if [ -d "tests" ]; then
                pytest tests/ >> "${LOG_DIR}/backend.log" 2>&1 || handle_error "backend"
            fi
            progress_meter "backend" 100
            
            # Deactivate virtual environment
            deactivate
            ;;
        frontend)
            cd "${PROJECT_ROOT}/frontend"
            if [ ! -f "package.json" ]; then
                echo -e "${FAIL} No package.json found in frontend directory" | tee -a "${LOG_DIR}/frontend.log"
                exit 1
            fi
            mkdir -p src
            
            if [ ! -d "node_modules" ]; then
                npm install --legacy-peer-deps >> "${LOG_DIR}/frontend.log" 2>&1 || handle_error "frontend"
            fi
            progress_meter "frontend" 50
            npm run build >> "${LOG_DIR}/frontend.log" 2>&1 || handle_error "frontend"
            progress_meter "frontend" 100
            ;;
        services)
            cd "${PROJECT_ROOT}/services" || { echo -e "${FAIL} Failed to enter services directory" | tee -a "${LOG_DIR}/services.log"; exit 1; }
            if [ ! -f "docker-compose.yml" ] || [ ! -f "start.sh" ]; then
                echo -e "${FAIL} No docker-compose.yml found in services directory" | tee -a "${LOG_DIR}/services.log"
                exit 1
            fi
            # Check for required Dockerfiles
            for service in backend frontend; do
                if [ ! -f "../${service}/Dockerfile" ]; then
                    echo -e "${FAIL} No Dockerfile found in ${service} directory" | tee -a "${LOG_DIR}/services.log"
                    exit 1
                fi
            done
            chmod +x start.sh
            ./start.sh ${ENVIRONMENT} >> "${LOG_DIR}/services.log" 2>&1 || handle_error "services"
            progress_meter "services" 100
            ;;
        deployments)
            cd "${PROJECT_ROOT}/deployments/aws"
            terraform init -backend=false >> "${LOG_DIR}/deployments.log" 2>&1 || handle_error "deployments"
            progress_meter "deployments" 50
            terraform validate >> "${LOG_DIR}/deployments.log" 2>&1 || handle_error "deployments"
            terraform apply -auto-approve >> "${LOG_DIR}/deployments.log" 2>&1 || handle_error "deployments"
            progress_meter "deployments" 100
            ;;
        tests)
            cd "${PROJECT_ROOT}"
            pytest tests/ >> "${LOG_DIR}/tests.log" 2>&1 || handle_error "tests"
            progress_meter "tests" 100
            ;;
    esac

    # Mark success
    echo "success" > "${STATUS_DIR}/${component}"
    touch "${LOG_DIR}/${component}.success"
    echo -e "${CHECK} ${GREEN}${component} built successfully${NC}"
    return 0
}

# Main execution
main() {
    init_build
    source "${PROJECT_ROOT}/deployments/.env" || { echo -e "${FAIL} Missing .env file"; exit 1; }
    validate_production
    
    # Build independent components in parallel
    build_component backend "services" &
    build_component frontend "" &
    build_component services "" &
    wait
    
    # Check if any builds failed
    if [ $failed_builds -gt 0 ]; then
        echo -e "\n${FAIL} ${RED}Some components failed to build${NC}"
        exit 1
    fi
    
    # Build dependent components
    build_component deployments "backend frontend services" &
    build_component tests "backend frontend services" &
    wait
    
    # Final status check
    if [ $failed_builds -gt 0 ]; then
        echo -e "\n${FAIL} ${RED}Build failed${NC}"
        exit 1
    fi
    
    echo -e "\n${CHECK} ${GREEN}All components built successfully${NC}"
    exit 0
}

main