# Quick Drupal Installer

Una herramienta de línea de comandos para instalar Drupal CMS rápidamente usando DDEV.

## Instalación

```bash
curl -o- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

O usando wget:

```bash
wget -qO- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

## Uso

```bash
# Instalación básica
quick-drupal mi-proyecto

# Instalación básica (solo crea el proyecto)
quick-drupal mi-proyecto

# Instalación completa con valores por defecto
quick-drupal -f mi-proyecto

# Instalación completa personalizada
quick-drupal -f mi-proyecto -u adminuser -p miclave -e admin@midominio.com -n "Mi Sitio Web"

# Ver la ayuda
quick-drupal --help
```

## Opciones

- `-h, --help`: Muestra la ayuda
- `-f, --full`: Realiza una instalación completa automática
- `-u, --user <usuario>`: Define el usuario administrador (default: admin)
- `-p, --pass <contraseña>`: Define la contraseña del administrador (default: admin)
- `-e, --email <email>`: Define el email del administrador (default: admin@example.com)
- `-n, --name <nombre>`: Define el nombre del sitio (default: Mi sitio Drupal CMS)

## Requisitos

- DDEV instalado
- Docker instalado
- Curl o wget (para la instalación)

## Licencia

MIT
