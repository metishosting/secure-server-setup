# Secure Server Setup Script

**Filename**: `secure-server-setup.sh`

## Description
"Secure Server Setup" is an automation script designed for the initial security setup of new servers. It handles several critical security enhancements:

### Features
- **System Update:** Initiates a complete system update, ensuring all packages are at their latest, secure versions.

- **Fail2Ban Installation and Configuration:** Installs Fail2Ban and adjusts settings for optimal security, including ban times and maximum retry attempts.

- **User Management:** Creates a new user with SSH key-based authentication and sudo access, enhancing security by disabling password-only access.

- **SSH Key Setup:** Establishes a secure SSH configuration for the new user, adding the necessary authentication key.

- **SSH Hardening:** Adjusts SSH server settings, including changing the default port, disabling root login, and enforcing additional security policies.

- **Service Management:** Restarts services like SSH and Fail2Ban to apply all configuration changes.

## Usage
This script is invaluable for server administrators looking to enforce a standardized initial security posture across new server deployments efficiently.
