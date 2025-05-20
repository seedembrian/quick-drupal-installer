#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar si tenemos sudo
if ! command -v sudo >/dev/null 2>&1; then
    echo -e "${RED}Error: Este script requiere sudo para instalar en /usr/bin${NC}"
    exit 1
fi

# Verificar permisos de sudo antes de continuar
echo -e "${YELLOW}Se requieren permisos de administrador para instalar en /usr/bin${NC}"
echo -n "Por favor, ingrese su contraseña: "
if ! sudo -v; then
    echo -e "\n${RED}Error: No se pudieron obtener permisos de administrador${NC}"
    exit 1
fi

# Variables de instalación
INSTALL_DIR="/usr/bin"
SCRIPT_NAME="quick-drupal"
REPO_URL="https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install-drupal.sh"

echo -e "\n${GREEN}Instalando Quick Drupal Installer...${NC}"

# Descargar el script a un archivo temporal
echo "Descargando script..."
TMP_FILE=$(mktemp)
curl -o "$TMP_FILE" "$REPO_URL" || {
    rm -f "$TMP_FILE"
    echo -e "${RED}Error al descargar el script${NC}"
    exit 1
}

# Mover el script a su ubicación final con sudo
echo "Instalando en $INSTALL_DIR..."
sudo mv "$TMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME" || {
    rm -f "$TMP_FILE"
    echo -e "${RED}Error al instalar el script${NC}"
    exit 1
}

# Hacer el script ejecutable
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo -e "${GREEN}¡Instalación completada!${NC}"
echo "Puedes usar el comando 'quick-drupal' desde cualquier ubicación."
echo "Ejemplo: quick-drupal --help"
