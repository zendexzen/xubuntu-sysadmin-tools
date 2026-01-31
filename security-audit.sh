#!/bin/bash
# AUDITORIA COMPLETA DE SEGURANÇA

echo "🔐 AUDITORIA DE SEGURANÇA - $(date)"
echo "==================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funções
check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
    fi
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 1. SISTEMA
echo "1. 📊 INFORMAÇÕES DO SISTEMA"
echo "---------------------------"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Usuários conectados: $(who | wc -l)"
echo ""

# 2. USUÁRIOS E PERMISSÕES
echo "2. 👥 USUÁRIOS E PERMISSÕES"
echo "--------------------------"
echo "Usuários com shell: $(grep -E ":/bin/(bash|sh|zsh)" /etc/passwd | wc -l)"
echo "Usuários UID 0: $(awk -F: '($3 == 0) {print $1}' /etc/passwd | tr '\n' ' ')"
echo ""

# 3. FIREWALL
echo "3. 🔥 FIREWALL STATUS"
echo "--------------------"
if command -v ufw >/dev/null; then
    sudo ufw status | head -10
else
    echo "UFW não instalado"
fi
echo ""

# 4. PORTAS ABERTAS
echo "4. 🔓 PORTAS ABERTAS"
echo "-------------------"
echo "Portas TCP ouvindo:"
sudo netstat -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | cut -d: -f2 | sort -un | head -20
echo ""

# 5. SSH/HONEYPOT
echo "5. 🎣 SSH & HONEYPOT"
echo "-------------------"
echo "SSH rodando: $(sudo systemctl is-active ssh 2>/dev/null)"
echo "Porta SSH configurada: $(sudo grep -E "^Port" /etc/ssh/sshd_config 2>/dev/null | head -1)"
echo "Honeypot encontrado: $(ps aux | grep -i honeypot | grep -v grep | wc -l)"
echo ""

# 6. ATUALIZAÇÕES DE SEGURANÇA
echo "6. 🔄 ATUALIZAÇÕES"
echo "-----------------"
echo "Atualizações de segurança pendentes:"
sudo apt list --upgradable 2>/dev/null | grep -i security | wc -l
echo ""

# 7. MALWARE/DETECÇÃO
echo "7. 🦠 DETECÇÃO DE MALWARE"
echo "------------------------"
echo "Processos suspeitos de rede:"
sudo netstat -tulpn 2>/dev/null | grep -E "(:1337|:31337|:4444)" | head -5 || echo "Nenhum encontrado"
echo ""

# 8. LOGS DE SEGURANÇA
echo "8. 📝 LOGS DE SEGURANÇA"
echo "----------------------"
echo "Últimos 5 logins SSH:"
sudo last -5 | grep -E "ssh|pts"
echo ""
echo "Tentativas falhadas recentes:"
sudo grep "Failed password" /var/log/auth.log 2>/dev/null | tail -3 || echo "Nenhuma encontrada"
echo ""

# 9. RECOMENDAÇÕES
echo "9. 💡 RECOMENDAÇÕES"
echo "------------------"

# Verificar senha root
if sudo passwd -S root 2>/dev/null | grep -q "L"; then
    echo "⚠️  Root está bloqueado (bom!)"
else
    echo "❌ Root não está bloqueado"
fi

# Verificar SSH root login
if sudo grep -q "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
    echo "✅ Root login via SSH desativado"
else
    echo "❌ PermitRootLogin não está definido como 'no'"
fi

# Verificar atualizações automáticas
if [ -f /etc/apt/apt.conf.d/20auto-upgrades ]; then
    echo "✅ Atualizações automáticas configuradas"
else
    echo "⚠️  Atualizações automáticas não configuradas"
fi

echo ""
echo "🔍 AUDITORIA COMPLETADA EM: $(date)"
