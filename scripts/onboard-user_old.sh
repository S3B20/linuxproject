#!/bin/bash
# onboard-user.sh: CloudByte Solutions onboarding automation
# Author: Sebastian Stein
# Created: 2026-11-25
# Purpose: Create a new user, set a temporary password, add them to a
#          team group, and force a password change on first login.
# Usage: sudo bash onboard-user.sh                       # interactive

set -eo pipefail




# --- Sudo guard -----------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "Error: this script must be run as root."
    echo "Try: sudo bash $0 $*"
    exit 1
fi

# --- Constants ------------------------------------------------------------
TEMP_PASSWORD="ChangeMe123!"

# --- Gather input ---------------------------------------------------------
read -rp "Username: "  username
read -rp "Group: "     group
read -rp "Full name: " fullname

# --- Guard: target group must exist ---------------------------------------
if ! getent group "$group" >/dev/null 2>&1; then
    echo "Error: group '$group' does not exist."
    echo "Hint: getent group | cut -d: -f1   to list available groups."
    exit 1
fi

# --- Guard: skip if user already exists -----------------------------------
if getent passwd "$username" >/dev/null 2>&1; then
    echo "Skip: user '$username' already exists."
    exit 0
fi

# --- Create the user ------------------------------------------------------
useradd -m -c "$fullname" "$username"
echo "$username:$TEMP_PASSWORD" | chpasswd
usermod -aG "$group" "$username"
chage -d 0 "$username"

echo "Created $username in group $group with temp password (must change on first login)."