#!/bin/bash
while true; do
    clear
    echo -e "\e[1;35m╔══════════════════════════════════════════════════════════╗\e[0m"
    echo -e "\e[1;35m║                🌹 DARK-ROSE MONITOR 🌹                   ║\e[0m"
    echo -e "\e[1;35m╠══════════════════════════════════════════════════════════╣\e[0m"
    
    # Sistema
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -c1-4)
    MEM=$(free -m | awk 'NR==2{printf "%.1f", $3*100/$2}')
    DISK=$(df -h / | awk 'NR==2{print $5}')
    
    echo -e "\e[1;34m📊 SISTEMA:\e[0m"
    echo -e "  CPU: \e[1;33m${CPU}%\e[0m | RAM: \e[1;33m${MEM}%\e[0m | DISCO: \e[1;33m${DISK}\e[0m"
    
    # Rede
    SSH_CONN=$(netstat -tn | grep :22 | wc -l)
    SSH_FAIL=$(journalctl -u ssh --since "5 minutes ago" | grep "Failed" | wc -l)
    
    echo -e "\e[1;34m🌐 REDE:\e[0m"
    echo -e "  SSH Ativas: \e[1;33m${SSH_CONN}\e[0m | Falhas(5min): \e[1;31m${SSH_FAIL}\e[0m"
    
    # Prometheus
    PROM_UP=$(curl -s http://localhost:9090/api/v1/query?query=up 2>/dev/null | jq -r '.data.result[0].value[1]' || echo "0")
    
    echo -e "\e[1;34m📡 PROMETHEUS:\e[0m"
    echo -e "  Status: \e[1;32m$([ "$PROM_UP" = "1" ] && echo "✅ UP" || echo "❌ DOWN")\e[0m"
    
    if [ "$PROM_UP" = "1" ]; then
        LOAD=$(curl -s http://localhost:9100/metrics 2>/dev/null | grep 'node_load1' | cut -d' ' -f2 | head -1)
        echo -e "  Load AVG: \e[1;33m${LOAD}\e[0m"
    fi
    
    # Últimos ataques
    echo -e "\e[1;34m🚨 ÚLTIMOS 5 FALHAS SSH:\e[0m"
    journalctl -u ssh --since "10 minutes ago" | grep "Failed" | tail -5 | while read line; do
        IP=$(echo $line | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
        echo -e "  \e[1;31m• ${IP}\e[0m"
    done
    
    echo -e "\e[1;35m╚══════════════════════════════════════════════════════════╝\e[0m"
    echo -e "\e[1;36mAtualizando em 5s... (Ctrl+C para sair)\e[0m"
    sleep 5
done
