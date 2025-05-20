#!/bin/bash

# Función de ayuda
show_help() {
  echo "Uso: $0 [opciones] nombre-proyecto"
  echo ""
  echo "Opciones:"
  echo "  -f, --full          Instalación completa automática"
  echo "  -u, --user USER     Usuario administrador (default: admin)"
  echo "  -p, --pass PASS     Contraseña del admin (default: admin)"
  echo "  -e, --email EMAIL   Email del admin (default: admin@example.com)"
  echo "  -n, --name NAME     Nombre del sitio (default: Mi sitio Drupal CMS)"
  echo "  -h, --help          Muestra esta ayuda"
  exit 0
}

# Variables por defecto
PROJECT_NAME="drupalcms"
FULL_INSTALL=false
ADMIN_USER="admin"
ADMIN_PASS="admin"
ADMIN_EMAIL="admin@example.com"
SITE_NAME="Mi sitio Drupal CMS"

# Leer argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
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
    --help|-h)
      show_help
      ;;
    -*)
      echo "❌ Opción desconocida: $1"
      show_help
      ;;
    *)
      PROJECT_NAME="$1"
      shift
      ;;
  esac
done

# Verificar que se proporcionó un nombre de proyecto
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Debe especificar un nombre para el proyecto"
  show_help
fi
PROFILE="drupal_cms_installer"

# Verificar DDEV
if ! command -v ddev &> /dev/null; then
  echo "❌ DDEV no está instalado. Instálalo desde https://ddev.readthedocs.io/"
  exit 1
fi

# === Evitar sobrescribir si ya existe ===
if [ -d "$PROJECT_NAME" ]; then
  echo "⚠️ La carpeta '$PROJECT_NAME' ya existe. Por favor elige otro nombre o elimínala primero."
  exit 1
fi

# Crear carpeta y navegar a ella
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

# Configurar y arrancar DDEV
echo "⚙️ Configurando DDEV..."
ddev config --project-type=drupal11 --docroot=web --project-name="$PROJECT_NAME" || exit 1

echo "🚀 Iniciando DDEV..."
ddev start || exit 1

# Descargar Drupal CMS
echo "📦 Descargando Drupal CMS..."
ddev composer create drupal/cms || exit 1

if [ "$FULL_INSTALL" = true ]; then
  echo "⚙️ Instalando Drupal con parámetros por defecto..."
  ddev drush site:install "$PROFILE" \
    --account-name="$ADMIN_USER" \
    --account-pass="$ADMIN_PASS" \
    --account-mail="$ADMIN_EMAIL" \
    --site-name="$SITE_NAME" \
    --yes

  echo "✅ Drupal CMS instalado."
  echo "🌐 URL del sitio: $(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')"
  echo "👤 Usuario: $ADMIN_USER"
  echo "🔑 Contraseña: $ADMIN_PASS"

  # Abrir en navegador (WSL o Linux/macOS)
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    SITE_URL=$(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')
    powershell.exe start "$SITE_URL"
  else
    ddev launch
  fi
else
  echo "📦 Proyecto Drupal creado."
  echo "ℹ️ Puedes acceder al instalador en el navegador con:"
  echo "    ddev launch"
fi
ddev status
