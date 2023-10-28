#!/bin/bash

echo "Starting the setup script."

# Check if the script is being run as root
if ! [ $(id -u) = 0 ]; then 
    echo "Please run this script as root or use sudo"
    exit 1 
fi

echo "Script is running as root. Proceeding with setup."

# Define variables for new user credentials and configuration paths
SSH_CONFIG_PATH="/etc/ssh/sshd_config"
FAIL2BAN_CONFIG_PATH="/etc/fail2ban/jail.local"
NEW_USER="ChangeMe"
USER_PASSWORD="ChangeThisVariable123!"
SSH_NEW_PORT="59420"
PUBLIC_SSH_KEY=""

# The next commands will stop the script if an error occurs.
set -e

echo "Updating system packages."
# Update and upgrade the system packages
apt update
apt upgrade -y  # The -y flag avoids interactive prompt

echo "Installing Fail2Ban for security."
# Install Fail2Ban for security
sudo apt install fail2ban -y

# echo "Removing any existing '${NEW_USER}' user."
# Delete user if it already existed
# deluser ${NEW_USER} || true  # The script will continue if the user does not exist
# rm -dr /home/${NEW_USER} || true  # Same as above

echo "Creating new user account."
# Create a new user without a default password and add it to the sudo group
adduser --disabled-password --gecos "" ${NEW_USER}
echo "${NEW_USER}:${USER_PASSWORD}" | chpasswd
usermod -aG sudo ${NEW_USER}

echo "Setting up SSH access for the new user."
# Set up SSH access for the new user
mkdir /home/${NEW_USER}/.ssh
touch /home/${NEW_USER}/.ssh/authorized_keys

# Fix directory permissions
chmod 700 /home/${NEW_USER}/.ssh

# Fix all key permissions
chmod 600 ~/.ssh/*

# Fix special files permissions
chmod 644 /home/${NEW_USER}/.ssh/authorized_keys

echo "${PUBLIC_SSH_KEY}" >> /home/${NEW_USER}/.ssh/authorized_keys

# edit owner of file and directory
chown -R ${NEW_USER}:${NEW_USER} /home/${NEW_USER}/.ssh
chown -R ${NEW_USER}:${NEW_USER} /home/${NEW_USER}/.ssh/authorized_keys

echo "Configuring SSH settings."
# Configure SSH: change port, set grace time, disable root login, and enforce strict modes
sed -i '/^#Port/s/^#//' ${SSH_CONFIG_PATH}
sed -i 's/^Port.*/Port '"$SSH_NEW_PORT"'/' ${SSH_CONFIG_PATH}
sed -i '/^#LoginGraceTime/s/^#//' ${SSH_CONFIG_PATH}
sed -i 's/^LoginGraceTime.*/LoginGraceTime 120/' ${SSH_CONFIG_PATH}
sed -i '/^#PermitRootLogin/s/^#//' ${SSH_CONFIG_PATH}
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' ${SSH_CONFIG_PATH}
sed -i '/^#StrictModes/s/^#//' ${SSH_CONFIG_PATH}
sed -i '/^#PasswordAuthentication/s/^#//' ${SSH_CONFIG_PATH}
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' ${SSH_CONFIG_PATH}

echo "Restarting SSH service."
# Restart SSH service to apply changes
systemctl restart sshd

echo "Configuring Fail2Ban settings."
# Copy the default Fail2Ban config to a new file for editing
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Adjust Fail2Ban settings: set ban time and specify that it's not enabled globally
sed -i 's/^# \(\[DEFAULT\]\)/\1/' ${FAIL2BAN_CONFIG_PATH}
sed -i '/^\[DEFAULT\]/!b;n;c\bantime  = 10m' ${FAIL2BAN_CONFIG_PATH}
sed -i '/^\[DEFAULT\]/a maxretry = 5\nenabled = false' ${FAIL2BAN_CONFIG_PATH}

# Enable and configure the [sshd] section for Fail2Ban
sed -i 's/^# \(\[sshd\]\)/\1/' ${FAIL2BAN_CONFIG_PATH}
sed -i 's/^# \(enabled = true\)/\1/' ${FAIL2BAN_CONFIG_PATH}
sed -i '/^enabled = true/a port = '"${SSH_NEW_PORT}"'\nfilter = sshd\nmaxretry = 3\nfindtime = 5m\nbantime  = 30m' ${FAIL2BAN_CONFIG_PATH}

echo "Restarting Fail2Ban service."
# Restart Fail2Ban service to apply changes
systemctl restart fail2ban

# If 'set -e' is used, it's good practice to disable it after the critical section to avoid unexpected behavior.
set +e

echo "Setup completed successfully."
