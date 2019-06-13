#!/bin/sh

# Update the OS to begin with to catch up on the latest packages.
sudo apt-get update -y
sudo apt-get upgrade -y

# Add hostname for bastion host
sudo hostnamectl set-hostname bastion-$ENVIRONMENT
sudo "127.0.0.1 bastion" > /etc/hosts
sudo reboot
