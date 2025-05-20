#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Verificar que se esté ejecutando como root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}Error: Este script debe ejecutarse con sudo${NC}"
    echo "Uso: sudo bash $0"
    exit 1
fi

# Variables de instalación
INSTALL_DIR="/usr/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

echo -e "${GREEN}Instalando Quick Drupal Installer...${NC}"

# Descargar el script
echo "Descargando script..."
TMP_FILE=$(mktemp)
curl -o "$TMP_FILE" "$REPO_URL" || {
    rm -f "$TMP_FILE"
    echo -e "${RED}Error al descargar el script${NC}"
    exit 1
}

# Instalar el script
echo "Instalando en $INSTALL_DIR..."
mv "$TMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME" || {
    rm -f "$TMP_FILE"
    echo -e "${RED}Error al instalar el script${NC}"
    exit 1
}

# Hacer el script ejecutable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo -e "${GREEN}¡Instalación completada!${NC}"
echo "Puedes usar el comando 'quick-drupal' desde cualquier ubicación."
echo "Ejemplo: quick-drupal --help"
