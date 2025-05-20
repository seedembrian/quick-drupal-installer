#!/bin/bash

# Help function
show_help() {
  echo "Usage: $0 [options] project-name"
  echo ""
  echo "Options:"
  echo "  -f, --full          Full automatic installation"
  echo "  -u, --user USER     Admin username (default: admin)"
  echo "  -p, --pass PASS     Admin password (default: admin)"
  echo "  -e, --email EMAIL   Admin email (default: admin@example.com)"
  echo "  -n, --name NAME     Site name (default: My Drupal CMS)"
  echo "  -h, --help          Show this help"
  exit 0
}

# Default variables
PROJECT_NAME="drupalcms"
FULL_INSTALL=false
ADMIN_USER="admin"
ADMIN_PASS="admin"
ADMIN_EMAIL="admin@example.com"
SITE_NAME="My Drupal CMS"

# Read arguments
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
      echo "❌ Unknown option: $1"
      show_help
      ;;
    *)
      PROJECT_NAME="$1"
      shift
      ;;
  esac
done

# Verify that a project name was provided
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ You must specify a project name"
  show_help
fi

PROFILE="drupal_cms_installer"

# Check DDEV
if ! command -v ddev &> /dev/null; then
  echo "❌ DDEV is not installed. Install it from https://ddev.readthedocs.io/"
  exit 1
fi

# === Avoid overwriting if exists ===
if [ -d "$PROJECT_NAME" ]; then
  echo "⚠️ The folder '$PROJECT_NAME' already exists. Please choose another name or delete it first."
  exit 1
fi

# Create folder and navigate to it
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

# Configure and start DDEV
echo "⚙️ Configuring DDEV..."
ddev config --project-type=drupal11 --docroot=web --project-name="$PROJECT_NAME" || exit 1

echo "🚀 Starting DDEV..."
ddev start || exit 1

# Download Drupal CMS
echo "📦 Downloading Drupal CMS..."
ddev composer create drupal/cms || exit 1

if [ "$FULL_INSTALL" = true ]; then
  echo "⚙️ Installing Drupal CMS, please wait..."
  ddev drush site:install "$PROFILE" \
    --account-name="$ADMIN_USER" \
    --account-pass="$ADMIN_PASS" \
    --account-mail="$ADMIN_EMAIL" \
    --site-name="$SITE_NAME" \
    --yes

  echo "✅ Drupal CMS installed."
  echo "🌐 Site URL: $(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')"
  echo "👤 User: $ADMIN_USER"
  echo "🔑 Password: $ADMIN_PASS"

  # Open in browser (WSL or Linux/macOS)
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    SITE_URL=$(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')
    powershell.exe start "$SITE_URL"
  else
    ddev launch
  fi
else
  echo "📦 Drupal project created."
  echo "🌐 Opening Drupal installer in your browser..."
  
  # Open in browser (WSL or Linux/macOS)
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    SITE_URL=$(ddev describe -j | grep -oP '"https_url"\s*:\s*"\K[^"]+')    
    powershell.exe start "$SITE_URL"
  else
    ddev launch
  fi
fi

echo "✨ Project status:"
ddev status
