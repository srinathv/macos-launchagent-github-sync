#!/bin/bash

#############################################
# Homebrew Update Script
# Automatically updates Homebrew and packages
#############################################

# Configuration
LOG_FILE="${HOME}/Library/Logs/brew-update.log"

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

# Start update process
log "========================================="
log "Starting Homebrew update process"
log "========================================="

# Update Homebrew itself
log "Updating Homebrew..."
if brew update 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Homebrew updated successfully"
else
    log_error "Failed to update Homebrew"
    exit 1
fi

# Upgrade installed packages
log "Upgrading installed packages..."
if brew upgrade 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Packages upgraded successfully"
else
    log_error "Failed to upgrade packages"
fi

# Clean up old versions
log "Cleaning up old versions..."
if brew cleanup 2>&1 | tee -a "$LOG_FILE"; then
    log_success "Cleanup completed"
else
    log_error "Cleanup failed"
fi

# Check for issues
log "Running brew doctor..."
brew doctor 2>&1 | tee -a "$LOG_FILE"

log "========================================="
log "Homebrew update process completed"
log "========================================="
