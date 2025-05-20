# Quick Drupal Installer

Una herramienta de línea de comandos para instalar Drupal CMS rápidamente usando DDEV.

## Instalación

1. Primero, descarga el script de instalación:

```bash
curl -o /tmp/install-drupal.sh https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh
```

O usando wget:

```bash
wget -O /tmp/install-drupal.sh https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh
```

2. Luego, ejecuta el script con sudo:

```bash
sudo bash /tmp/install-drupal.sh && rm /tmp/install-drupal.sh
```

## Uso

```bash
# Instalación básica
quick-drupal mi-proyecto

# Instalación completa con parámetros personalizados
quick-drupal -f mi-proyecto --user adminuser --pass miclave --email admin@midominio.com

# Ver la ayuda
quick-drupal --help
```

## Opciones

- `-h, --help`: Muestra la ayuda
- `-f, --full`: Realiza una instalación completa automática
- `-u, --user <usuario>`: Define el usuario administrador
- `-p, --pass <contraseña>`: Define la contraseña del administrador
- `-e, --email <email>`: Define el email del administrador
- `-n, --name <nombre>`: Define el nombre del sitio
- `--php <version>`: Define la versión de PHP
- `--drupal <version>`: Define la versión de Drupal

## Requisitos

- DDEV instalado
- Docker instalado
- Curl o wget (para la instalación)

## Licencia

MIT
