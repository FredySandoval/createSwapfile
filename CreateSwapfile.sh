#!/bin/bash
fallocate -l 2G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=$((1024 * 1024 * 2))
chown root:root /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
mount -a
