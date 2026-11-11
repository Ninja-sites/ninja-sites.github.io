#!/bin/sh
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq openssh-server
systemctl enable --now ssh
U="${SUDO_USER:-$(id -un)}"
H=$(getent passwd "$U" | cut -d: -f6)
mkdir -p "$H/.ssh"; chmod 700 "$H/.ssh"
touch "$H/.ssh/authorized_keys"
grep -q 'ninja@hermes-laptop-access' "$H/.ssh/authorized_keys" || echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6KNxrjfaagyU8ppXDUYKvCxKmRRoCEW7e+aWAC7o8D ninja@hermes-laptop-access' >> "$H/.ssh/authorized_keys"
chmod 600 "$H/.ssh/authorized_keys"
chown -R "$U" "$H/.ssh"
echo "$U ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-ninja
chmod 440 /etc/sudoers.d/99-ninja
if command -v ufw >/dev/null && ufw status 2>/dev/null | grep -q 'Status: active'; then
  ufw allow from 192.168.128.0/24 to any port 22 proto tcp
fi
echo "=== DONE — العنوان: ==="
hostname -I
