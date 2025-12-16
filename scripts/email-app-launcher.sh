#!/bin/bash

#############################################
# Email App Launcher Script
# Opens/focuses email apps periodically
#############################################

# Configuration
LOG_FILE="${HOME}/Library/Logs/email-launcher.log"
EMAIL_APPS=("Proton Mail" "Microsoft Outlook")

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

# Start process
log "========================================="
log "Starting email app launcher"
log "========================================="

# Function to check if app is running
is_app_running() {
    local app_name="$1"
    osascript -e "tell application \"System Events\" to (name of processes) contains \"$app_name\"" 2>/dev/null
}

# Function to launch or focus app
launch_or_focus_app() {
    local app_name="$1"
    
    log "Processing: $app_name"
    
    # Check if the app exists
    if [ ! -d "/Applications/${app_name}.app" ]; then
        log_error "  App not found: /Applications/${app_name}.app"
        return 1
    fi
    
    # Launch or activate the app
    if osascript -e "tell application \"$app_name\" to activate" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "  Launched/focused: $app_name"
    else
        log_error "  Failed to launch/focus: $app_name"
        return 1
    fi
}

# Launch each email app
for app in "${EMAIL_APPS[@]}"; do
    launch_or_focus_app "$app"
done

log "========================================="
log "Email app launcher completed"
log "========================================="
