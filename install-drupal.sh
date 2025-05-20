#!/bin/bash

# Colores y estilos
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Variables por defecto
PROJECT_NAME="drupalcms"
FULL_INSTALL=false
ADMIN_USER="admin"
ADMIN_PASS="admin"
ADMIN_EMAIL="admin@example.com"
SITE_NAME="Mi sitio Drupal CMS"
PROFILE="standard"
PHP_VERSION="8.2"
DRUPAL_VERSION="^10"

# Función para mostrar la ayuda
show_help() {
    echo -e "${BOLD}Instalador de Drupal CMS${NC}"
    echo
    echo "Uso: $0 [opciones] [nombre-proyecto]"
    echo
    echo "Opciones:"
    echo "  -h, --help                 Muestra esta ayuda"
    echo "  -f, --full                 Realiza una instalación completa automática"
    echo "  -u, --user <usuario>       Define el usuario administrador (default: admin)"
    echo "  -p, --pass <contraseña>    Define la contraseña del administrador (default: admin)"
    echo "  -e, --email <email>        Define el email del administrador (default: admin@example.com)"
    echo "  -n, --name <nombre>        Define el nombre del sitio"
    echo "  --php <version>            Define la versión de PHP (default: 8.2)"
    echo "  --drupal <version>         Define la versión de Drupal (default: ^10)"
    echo
    echo "Ejemplo:"
    echo "  $0 -f mi-proyecto --user adminuser --pass secreto"
    exit 0
}

# Función para mostrar mensajes
log_message() {
    local type=$1
    local message=$2
    case $type in
        "info")    echo -e "${BLUE}ℹ️ ${NC}$message" ;;
        "success") echo -e "${GREEN}✅ ${NC}$message" ;;
        "error")   echo -e "${RED}❌ ${NC}$message" ;;
        "warning") echo -e "${YELLOW}⚠️ ${NC}$message" ;;
    esac
}

# Función para verificar requisitos
check_requirements() {
    # Verificar DDEV
    if ! command -v ddev &> /dev/null; then
        log_message "error" "DDEV no está instalado. Instálalo desde https://ddev.readthedocs.io/"
        exit 1
    fi

    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_message "error" "Docker no está instalado. Es requerido por DDEV."
        exit 1
    fi

    # Verificar espacio en disco (mínimo 2GB)
    local free_space
    free_space=$(df -P . | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt 2097152 ]; then # 2GB en KB
        log_message "error" "Espacio insuficiente en disco. Se requieren al menos 2GB libres."
        exit 1
    }
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            ;;
        --full|-f)
            FULL_INSTALL=true
            shift
            ;;
        --user|-u)
            ADMIN_USER="$2"
            shift 2
            ;;
        --pass|-p)
            ADMIN_PASS="$2"
            shift 2
            ;;
        --email|-e)
            ADMIN_EMAIL="$2"
            shift 2
            ;;
        --name|-n)
            SITE_NAME="$2"
            shift 2
            ;;
        --php)
            PHP_VERSION="$2"
            shift 2
            ;;
        --drupal)
            DRUPAL_VERSION="$2"
            shift 2
            ;;
        *)
            if [ -z "$PROJECT_NAME" ]; then
                PROJECT_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Validar parámetros
if [[ ! $ADMIN_EMAIL =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    log_message "error" "El email proporcionado no es válido"
    exit 1
fi

# Verificar requisitos
check_requirements

# Verificar si el proyecto ya existe
if [ -d "$PROJECT_NAME" ]; then
    log_message "error" "La carpeta '$PROJECT_NAME' ya existe. Por favor elige otro nombre o elimínala primero."
    exit 1
fi

# Crear carpeta y navegar a ella
log_message "info" "Creando proyecto '$PROJECT_NAME'..."
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

# Configurar y arrancar DDEV
log_message "info" "Configurando DDEV..."
ddev config --project-type=drupal10 --docroot=web --project-name="$PROJECT_NAME" --php-version="$PHP_VERSION"
ddev start

# Descargar Drupal
log_message "info" "Descargando Drupal $DRUPAL_VERSION..."
ddev composer create "drupal/recommended-project:$DRUPAL_VERSION" --no-interaction

# Instalar dependencias adicionales
log_message "info" "Instalando módulos adicionales..."
ddev composer require drush/drush

if [ "$FULL_INSTALL" = true ]; then
    log_message "info" "Iniciando instalación automática de Drupal..."
    
    # Limpiar archivos de instalación previos si existen
    if [ -f web/sites/default/settings.php ]; then
        chmod u+w web/sites/default/settings.php web/sites/default
        rm web/sites/default/settings.php
    fi
    
    # Instalar Drupal
    ddev drush site:install "$PROFILE" \
        --account-name="$ADMIN_USER" \
        --account-pass="$ADMIN_PASS" \
        --account-mail="$ADMIN_EMAIL" \
        --site-name="$SITE_NAME" \
        --yes

    # Configuraciones post-instalación
    ddev drush config:set system.site name "$SITE_NAME" -y
    ddev drush cache:rebuild

    # Mostrar información de acceso
    SITE_URL=$(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')
    log_message "success" "Drupal instalado correctamente"
    echo -e "\n${BOLD}Información de acceso:${NC}"
    echo -e "🌐 URL del sitio: ${BLUE}$SITE_URL${NC}"
    echo -e "👤 Usuario: ${GREEN}$ADMIN_USER${NC}"
    echo -e "🔑 Contraseña: ${GREEN}$ADMIN_PASS${NC}"

    # Abrir en navegador
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        powershell.exe start "$SITE_URL"
    else
        ddev launch
    fi
else
    log_message "info" "Proyecto Drupal creado. Ejecuta 'ddev launch' para acceder al instalador web."
fi

# Mostrar estado final
ddev status

log_message "success" "¡Proceso completado!"
