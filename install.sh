#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Script name and repo URL
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

# Try to use /usr/bin if we have sudo access, otherwise fallback to ~/.local/bin
if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    INSTALL_DIR="/usr/bin"
    USE_SUDO=true
    echo -e "${GREEN}Installing globally in $INSTALL_DIR${NC}"
else
    INSTALL_DIR="$HOME/.local/bin"
    USE_SUDO=false
    echo -e "${YELLOW}Installing locally in $INSTALL_DIR${NC}"
fi

# Check if it's an update
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo -e "${GREEN}Updating Quick Drupal Installer...${NC}"
    # Create backup of existing script
    cp "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME.backup"
    UPDATE=true
else
    echo -e "${GREEN}Installing Quick Drupal Installer...${NC}"
    UPDATE=false
fi

# Create installation directory if it doesn't exist and we're using local install
if [ "$USE_SUDO" = false ]; then
    mkdir -p "$INSTALL_DIR"
fi

# Download the script (using sudo if necessary)
echo "Downloading script..."
if [ "$USE_SUDO" = true ]; then
    curl -o "/tmp/$SCRIPT_NAME" "$REPO_URL" && sudo mv "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME" || {
    if [ "$UPDATE" = true ]; then
        echo -e "${RED}Error downloading update. Restoring backup...${NC}"
        mv "$INSTALL_DIR/$SCRIPT_NAME.backup" "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    echo -e "${RED}Error downloading the script${NC}"
    exit 1
}

# Remove backup if update was successful
if [ "$UPDATE" = true ]; then
    rm "$INSTALL_DIR/$SCRIPT_NAME.backup"
    echo -e "${GREEN}Update completed successfully!${NC}"
fi

# Make the script executable
if [ "$USE_SUDO" = true ]; then
    sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
else
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
fi

# Only add to PATH if using local installation
if [ "$USE_SUDO" = false ] && [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "${GREEN}Installation completed!${NC}"
echo "You can now use the 'quick-drupal' command from any location."
echo "Example: quick-drupal --help"
