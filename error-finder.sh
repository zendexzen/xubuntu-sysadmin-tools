#!/bin/bash
echo "--- ÚLTIMOS 5 ERROS CRÍTICOS DO SISTEMA ---"
journalctl -p 3 -n 5 --no-pager
echo ""
echo "--- ERROS DE CONEXÃO SSH ---"
grep "Failed password" /var/log/auth.log | tail -n 3
