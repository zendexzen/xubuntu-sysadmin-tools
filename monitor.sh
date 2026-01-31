#!/bin/bash
echo "=== $(date) ==="
echo "Conexões SSH:"
sudo netstat -tn | grep :22
echo ""
echo "Tentativas falhadas:"
sudo journalctl -u ssh --since "1 hour ago" | grep "Failed"
echo ""
echo "Portas abertas:"
sudo ss -tulpn | grep LISTEN
