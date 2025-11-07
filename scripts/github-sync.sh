#!/bin/bash

#############################################
# GitHub Repository Sync Script
# Automatically clones or updates GitHub repos
#############################################

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="${SCRIPT_DIR}/../examples/repos.conf"
SYNC_DIR="${HOME}/GitHubSync"  # Default directory for synced repos
LOG_FILE="${HOME}/Library/Logs/github-sync.log"

# Colors for terminal output (will be stripped in logs)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "$LOG_FILE" >&2
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" | tee -a "$LOG_FILE"
}

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    log_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Create sync directory if it doesn't exist
if [ ! -d "$SYNC_DIR" ]; then
    log "Creating sync directory: $SYNC_DIR"
    mkdir -p "$SYNC_DIR"
fi

# Start sync process
log "========================================="
log "Starting GitHub repository sync"
log "========================================="

# Read configuration file
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Extract repo URL
    repo_url=$(echo "$line" | xargs)

    # Extract repository name from URL
    repo_name=$(basename "$repo_url" .git)

    # Full path to local repository
    local_path="${SYNC_DIR}/${repo_name}"

    log "Processing: $repo_name"

    if [ -d "$local_path/.git" ]; then
        # Repository exists, pull updates
        log "  Repository exists, pulling updates..."
        cd "$local_path" || {
            log_error "  Failed to change directory to $local_path"
            continue
        }

        # Fetch and pull
        if git fetch origin && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null; then
            log_success "  Updated $repo_name"
        else
            log_error "  Failed to update $repo_name"
        fi
    else
        # Repository doesn't exist, clone it
        log "  Cloning repository..."
        if git clone "$repo_url" "$local_path"; then
            log_success "  Cloned $repo_name"
        else
            log_error "  Failed to clone $repo_name from $repo_url"
        fi
    fi

done < "$CONFIG_FILE"

log "========================================="
log "Sync process completed"
log "========================================="
