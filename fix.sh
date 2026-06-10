#!/bin/bash

echo "=== Chromium Server Fix ==="
echo ""

# Container neustarten
echo "[1/5] Container neustarten..."
docker restart chromium_3 2>/dev/null && echo "OK" || echo "Container nicht gefunden, weiter..."
sleep 5

# Alten Swap deaktivieren
echo "[2/5] Alten Swap deaktivieren..."
swapoff -a 2>/dev/null

# Swapfile erstellen
echo "[3/5] Neuen Swap erstellen (4GB)..."
if [ -f /swapfile ]; then
    rm /swapfile
fi
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# fstab aktualisieren
echo "[4/5] fstab aktualisieren..."
sed -i '/swapfile/d' /etc/fstab
sed -i '/swap/d' /etc/fstab
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Swappiness setzen
echo "[5/5] Swappiness auf 10 setzen..."
sed -i '/swappiness/d' /etc/sysctl.conf
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p 2>/dev/null

echo ""
echo "=== Fertig! ==="
free -h
