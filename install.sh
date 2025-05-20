#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Installation directory
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

echo -e "${GREEN}Installing Quick Drupal Installer...${NC}"

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Download the script
echo "Downloading script..."
curl -o "$INSTALL_DIR/$SCRIPT_NAME" "$REPO_URL" || {
    echo -e "${RED}Error downloading the script${NC}"
    exit 1
}

# Make the script executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "${GREEN}Installation completed!${NC}"
echo "You can now use the 'quick-drupal' command from any location."
echo "Example: quick-drupal --help"
