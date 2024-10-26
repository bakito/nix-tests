#!/bin/bash
apt update
apt upgrade -y
apt install -y curl xz-utils sudo nano

useradd -m -d /home/bakito -s /usr/bin/bash bakito
usermod -aG sudo bakito
echo "bakito:bakito" | chpasswd

mkdir -m 0755 /nix && chown bakito /nix

