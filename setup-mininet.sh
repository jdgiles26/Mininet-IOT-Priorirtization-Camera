#!/bin/bash
# setup-mininet.sh - Set up Mininet on macOS via Multipass
# Usage: bash setup-mininet.sh

set -e

PROJECT_DIR="$(dirname "$0")"
echo "=== Step 1: Installing Multipass ==="
brew install --cask multipass

echo "=== Step 2: Launching Multipass Ubuntu VM ==="
multipass launch --name mininet-vm --cpus 4 --memory 4G --disk 20G

echo "=== Step 3: Installing Mininet in VM ==="
multipass exec mininet-vm -- bash -c '
sudo apt-get update -qq
sudo apt-get install -y -qq mininet > /dev/null 2>&1
echo "Mininet version: $(mn --version)"
'

echo "=== Step 4: Copying project files to VM ==="
multipass mount "$PROJECT_DIR" mininet-vm:/home/ubuntu/iotDynamicPri

echo ""
echo "=== DONE ==="
echo ""
echo "To run the topology:"
echo "  multipass shell mininet-vm"
echo "  cd /home/ubuntu/iotDynamicPri"
echo "  sudo mn --controller=remote,ip=192.168.56.101 --custom=iot_sdn.py --topo=mytopo"
echo ""
echo "NOTE: The controller at 192.168.56.101 must be reachable from the VM."
echo "If ONOS is running in another VM, ensure both VMs are on the same network."
