#!/bin/bash

#############################################
# Installation Script for macOS Launch Agents
# Installs GitHub sync, Brew update, and Email launcher
#############################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}macOS Launch Agents Installation${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# Function to install a launch agent
install_agent() {
    local plist_name="$1"
    local description="$2"
    
    echo -e "${YELLOW}Installing: ${description}${NC}"
    
    # Copy plist file
    cp "${SCRIPT_DIR}/examples/${plist_name}" "${LAUNCH_AGENTS_DIR}/"
    
    # Unload if already loaded
    launchctl unload "${LAUNCH_AGENTS_DIR}/${plist_name}" 2>/dev/null || true
    
    # Load the agent
    launchctl load "${LAUNCH_AGENTS_DIR}/${plist_name}"
    
    echo -e "${GREEN}✓ ${description} installed and loaded${NC}"
    echo ""
}

# Create LaunchAgents directory if it doesn't exist
mkdir -p "${LAUNCH_AGENTS_DIR}"

# Make scripts executable
chmod +x "${SCRIPT_DIR}/scripts/github-sync.sh"
chmod +x "${SCRIPT_DIR}/scripts/brew-update.sh"
chmod +x "${SCRIPT_DIR}/scripts/email-app-launcher.sh"

echo "Which launch agents would you like to install?"
echo ""
echo "1) GitHub Sync (runs daily at 6:00 AM)"
echo "2) Brew Update (runs daily at 7:00 AM)"
echo "3) Email Launcher (runs every hour)"
echo "4) All of the above"
echo "5) Custom selection"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        install_agent "com.github.sync.plist" "GitHub Sync"
        ;;
    2)
        install_agent "com.brew.update.plist" "Brew Update"
        ;;
    3)
        install_agent "com.email.launcher.plist" "Email Launcher"
        ;;
    4)
        install_agent "com.github.sync.plist" "GitHub Sync"
        install_agent "com.brew.update.plist" "Brew Update"
        install_agent "com.email.launcher.plist" "Email Launcher"
        ;;
    5)
        read -p "Install GitHub Sync? (y/n): " install_github
        if [[ $install_github == "y" ]]; then
            install_agent "com.github.sync.plist" "GitHub Sync"
        fi
        
        read -p "Install Brew Update? (y/n): " install_brew
        if [[ $install_brew == "y" ]]; then
            install_agent "com.brew.update.plist" "Brew Update"
        fi
        
        read -p "Install Email Launcher? (y/n): " install_email
        if [[ $install_email == "y" ]]; then
            install_agent "com.email.launcher.plist" "Email Launcher"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Installed launch agents:"
launchctl list | grep -E "com.github.sync|com.brew.update|com.email.launcher" || echo "None running yet"
echo ""
echo "Log files location: ~/Library/Logs/"
echo ""
echo "To test scripts manually:"
echo "  ./scripts/github-sync.sh"
echo "  ./scripts/brew-update.sh"
echo "  ./scripts/email-app-launcher.sh"
echo ""
echo "To uninstall, run: ./uninstall.sh"
