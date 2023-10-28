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

## How to Use
Follow these steps to download, prepare, and execute the script:

1. **Download the Script:**
    ```
    wget https://raw.githubusercontent.com/metishosting/secure-server-setup/main/secure-server-setup.sh
    ```

2. **Edit the Script Variables:**
   Open the script in a text editor (here, we're using nano, but you can use any editor you prefer):
    ```
    sudo nano secure-server-setup.sh
    ```
   Inside the editor, modify the variables at the beginning of the script (e.g., `NEW_USER`, `USER_PASSWORD`, `SSH_NEW_PORT`, `PUBLIC_SSH_KEY`, etc.) to match your preferred settings.

3. **Make the Script Executable:**
    ```
    sudo chmod +x secure-server-setup.sh
    ```

4. **Run the Script:**
   Execute the script with administrative privileges:
    ```
    sudo ./secure-server-setup.sh
    ```
Follow the on-screen prompts, if any, to complete the setup process.
