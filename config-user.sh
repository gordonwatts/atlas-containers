#!/bin/bash
# Run as root, creates the default user, and configures wsl2 to start
# with that user.

read -p "Enter username: " username
adduser $username
passwd $username

gpasswd -a $username wheel
usermod -aG users $username

echo "[user]" >> /etc/wsl.conf
echo "default=$username" >> /etc/wsl.conf
