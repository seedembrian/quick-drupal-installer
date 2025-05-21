#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Installation variables
INSTALL_DIR="/usr/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    echo -e "${RED}Error: 'sudo' command is required for installation${NC}"
    exit 1
fi

# Request sudo access
echo -e "${YELLOW}Administrator permissions are required to install in $INSTALL_DIR${NC}"
echo -n "Please enter your password: "
if ! sudo -v; then
    echo -e "\n${RED}Error: Administrator access denied${NC}"
    exit 1
fi

echo -e "\n${GREEN}Installing Quick Drupal Installer...${NC}"

# Download script
echo "Downloading script..."
TMP_FILE=$(mktemp)
curl -o "$TMP_FILE" "$REPO_URL" || {
    rm -f "$TMP_FILE"
    echo -e "${RED}Error downloading the script${NC}"
    exit 1
}

# Install script
echo "Installing in $INSTALL_DIR..."
sudo mv "$TMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME" && \
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME" && \
echo -e "${GREEN}Installation completed!${NC}" && \
echo "You can now use the 'quick-drupal' command from any location." && \
echo "Example: quick-drupal --help"
