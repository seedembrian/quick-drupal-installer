#!/bin/bash

# Colores
GREEN='\033[0;32m'
NC='\033[0m'

# Variables de instalación
INSTALL_DIR="/usr/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

echo -e "${GREEN}Installing Quick Drupal Installer...${NC}"

# Download script
echo "Downloading script..."
curl -o "$INSTALL_DIR/$SCRIPT_NAME" "$REPO_URL" && \
chmod +x "$INSTALL_DIR/$SCRIPT_NAME" && \
echo -e "${GREEN}Installation completed!${NC}" && \
echo "You can now use the 'quick-drupal' command from any location." && \
echo "Example: quick-drupal --help"
