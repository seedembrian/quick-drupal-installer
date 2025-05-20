# Quick Drupal Installer

A command-line tool to quickly install Drupal CMS using DDEV.

## Installation

Using curl:

```bash
curl -o- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

## Usage

```bash
# Basic installation
quick-drupal my-project

# Full installation with custom parameters
quick-drupal -f my-project --user adminuser --pass mypass --email admin@mydomain.com

# Show help
quick-drupal --help
```

## Options

- `-h, --help`: Show help
- `-f, --full`: Perform a full automatic installation
- `-u, --user <username>`: Set admin username
- `-p, --pass <password>`: Set admin password
- `-e, --email <email>`: Set admin email
- `-n, --name <name>`: Set site name
- `--php <version>`: Set PHP version
- `--drupal <version>`: Set Drupal version

## Requirements

- DDEV installed
- Docker installed
- Curl or wget (for installation)

## License

MIT
