# Quick Drupal Installer

A command line tool to quickly install Drupal CMS using DDEV.

## Installation

The script will try to install globally in `/usr/bin` if you have sudo access. If not, it will fall back to a local installation in `~/.local/bin`.

```bash
curl -o- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

> **Important**: After installation, you need to either:
> 1. Close and reopen your terminal, or
> 2. Run: `source ~/.bashrc`
> 
> This is required for the `quick-drupal` command to be available.

## Usage

```bash
# Basic installation
quick-drupal my-project

# Basic installation (only creates the project)
quick-drupal my-project

# Full installation with default values
quick-drupal -f my-project

# Custom full installation
quick-drupal -f my-project -u adminuser -p mypass -e admin@mydomain.com -n "My Website"

# Show help
quick-drupal --help
```

## Options

- `-h, --help`: Show help
- `-f, --full`: Perform a full automatic installation
- `-u, --user <username>`: Set admin username (default: admin)
- `-p, --pass <password>`: Set admin password (default: admin)
- `-e, --email <email>`: Set admin email (default: admin@example.com)
- `-n, --name <name>`: Set site name (default: My Drupal CMS)

## Updating

To update to the latest version, run the installation command again:

```bash
curl -o- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

The script will automatically update the existing installation.

## Requirements

- DDEV installed
- Docker installed
- Curl or wget (for installation)

## License

MIT
