#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Directorio de instalación
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

echo -e "${GREEN}Instalando Quick Drupal Installer...${NC}"

# Crear directorio de instalación si no existe
mkdir -p "$INSTALL_DIR"

# Descargar el script
echo "Descargando script..."
curl -o "$INSTALL_DIR/$SCRIPT_NAME" "$REPO_URL" || {
    echo -e "${RED}Error al descargar el script${NC}"
    exit 1
}

# Hacer el script ejecutable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Verificar si el directorio está en el PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Agregando $INSTALL_DIR al PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

echo -e "${GREEN}¡Instalación completada!${NC}"
echo "Puedes usar el comando 'quick-drupal' desde cualquier ubicación."
echo "Ejemplo: quick-drupal --help"
