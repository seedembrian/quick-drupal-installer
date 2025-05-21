# Quick Drupal Installer

A command-line tool to quickly install Drupal CMS using DDEV.

## Installation

Choose one of these methods:

1. Using curl:

```bash
curl -o- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

2. Using wget:

```bash
wget -qO- https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh | bash
```

3. Or download and run manually:

```bash
# Download the installer
curl -o install-drupal.sh https://raw.githubusercontent.com/seedembrian/quick-drupal-installer/master/install.sh

# Make it executable
chmod +x install-drupal.sh

# Run the installer
./install-drupal.sh
```

> **Note**: The installer will create a `quick-drupal` script in `/usr/bin`, making the command available system-wide. You will be prompted for your password as administrator permissions are required.

> **Important**: The installer needs:
> - `sudo` access to write to `/usr/bin`
> - `curl` or `wget` for downloading
> - Internet connection to fetch the installation script

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
