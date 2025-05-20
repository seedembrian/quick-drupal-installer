#!/bin/bash

# Variables por defecto
PROJECT_NAME="drupalcms"
FULL_INSTALL=false

# Leer argumentos
for arg in "$@"; do
  case $arg in
    --full|-f)
      FULL_INSTALL=true
      shift
      ;;
    *)
      PROJECT_NAME="$arg"
      ;;
  esac
done

# Configuraciones de instalación automatizada
ADMIN_USER="admin"
ADMIN_PASS="admin"
ADMIN_EMAIL="admin@example.com"
SITE_NAME="Mi sitio Drupal CMS"
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
ddev config --project-type=drupal11 --docroot=web --project-name="$PROJECT_NAME"
ddev start

# Descargar Drupal CMS
ddev composer create-project drupal/cms .

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
