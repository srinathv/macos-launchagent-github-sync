#!/bin/bash

#############################################
# Uninstallation Script for macOS Launch Agents
#############################################

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}macOS Launch Agents Uninstallation${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo ""

# Function to uninstall a launch agent
uninstall_agent() {
    local plist_name="$1"
    local description="$2"
    
    echo -e "${YELLOW}Uninstalling: ${description}${NC}"
    
    # Unload the agent
    if launchctl unload "${LAUNCH_AGENTS_DIR}/${plist_name}" 2>/dev/null; then
        echo -e "${GREEN}✓ ${description} unloaded${NC}"
    else
        echo -e "${RED}✗ ${description} was not loaded${NC}"
    fi
    
    # Remove plist file
    if [ -f "${LAUNCH_AGENTS_DIR}/${plist_name}" ]; then
        rm "${LAUNCH_AGENTS_DIR}/${plist_name}"
        echo -e "${GREEN}✓ ${description} plist removed${NC}"
    else
        echo -e "${RED}✗ ${description} plist not found${NC}"
    fi
    
    echo ""
}

echo "Which launch agents would you like to uninstall?"
echo ""
echo "1) GitHub Sync"
echo "2) Brew Update"
echo "3) Email Launcher"
echo "4) All of the above"
echo "5) Custom selection"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        uninstall_agent "com.github.sync.plist" "GitHub Sync"
        ;;
    2)
        uninstall_agent "com.brew.update.plist" "Brew Update"
        ;;
    3)
        uninstall_agent "com.email.launcher.plist" "Email Launcher"
        ;;
    4)
        uninstall_agent "com.github.sync.plist" "GitHub Sync"
        uninstall_agent "com.brew.update.plist" "Brew Update"
        uninstall_agent "com.email.launcher.plist" "Email Launcher"
        ;;
    5)
        read -p "Uninstall GitHub Sync? (y/n): " uninstall_github
        if [[ $uninstall_github == "y" ]]; then
            uninstall_agent "com.github.sync.plist" "GitHub Sync"
        fi
        
        read -p "Uninstall Brew Update? (y/n): " uninstall_brew
        if [[ $uninstall_brew == "y" ]]; then
            uninstall_agent "com.brew.update.plist" "Brew Update"
        fi
        
        read -p "Uninstall Email Launcher? (y/n): " uninstall_email
        if [[ $uninstall_email == "y" ]]; then
            uninstall_agent "com.email.launcher.plist" "Email Launcher"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Uninstallation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Note: Log files in ~/Library/Logs/ were not deleted."
echo "You can manually remove them if desired."
