#!/bin/bash

# Check if argument is "on" or "off"
if [ "$1" = "on" ]; then
  # Check if the nameserver lines already exist in /etc/resolv.conf
  if ! grep -q "nameserver 178.22.122.100" /etc/resolv.conf || ! grep -q "nameserver 185.51.200.2" /etc/resolv.conf; then
    # Add the nameserver lines to the top of /etc/resolv.conf
    echo -e "nameserver 178.22.122.100\nnameserver 185.51.200.2\n$(cat /etc/resolv.conf)" | sudo tee /etc/resolv.conf > /dev/null
    echo "Nameservers added successfully."
  else
    echo "Nameservers already exist in /etc/resolv.conf."
  fi
elif [ "$1" = "off" ]; then
  # Remove the nameserver lines from /etc/resolv.conf
  sudo sed -i '/nameserver 178.22.122.100/d' /etc/resolv.conf
  sudo sed -i '/nameserver 185.51.200.2/d' /etc/resolv.conf
  
  echo "Nameservers removed successfully."
else
  echo "Invalid argument. Please specify either 'on' or 'off'."
fi

# Reset local DNS cache
sudo systemctl restart systemd-resolved.service
echo "Local DNS cache reset."
