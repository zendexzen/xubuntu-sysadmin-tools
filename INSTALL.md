# 🌹 Dark-Rose Cyber Operations (M58p Edition)

Este repositório contém o ecossistema de automação e monitorização desenvolvido para o servidor **ThinkCentre M58p**, integrando IA local e métricas de infraestrutura.

## 🛠️ Stack Tecnológica
- **OS:** Xubuntu/Ubuntu Server (Optimized)
- **IA:** Ollama (TinyLlama 1.1B)
- **Database:** PostgreSQL & MariaDB
- **Web:** Nginx & Flask (dev-fullstack conda env)
- **Monitorização:** Prometheus & Node Exporter
- **VPN:** Tailscale (Zero Trust Network)

## 📂 Descrição dos Scripts

| Script | Função |
| :--- | :--- |
| `dark-rose-monitor.sh` | Dashboard visual (ANSI) com métricas de CPU, RAM e integridade SSH. |
| `network-health.sh` | Diagnóstico de IPs locais, Tailscale e latência de rede. |
| `sys-dashboard.sh` | Sumário executivo de processos e carga de sistema. |
| `security-audit.sh` | Verificação de portas abertas (Nmap/SS) e tentativas de intrusão. |
| `error-finder.sh` | Scanner automático de logs (`dmesg`, `syslog`) para detecção de falhas. |

## 🚀 Como Instalar

1. **Clonar o repositório:**
   ```bash
   git clone [https://github.com/zendexzen/xubuntu-sysadmin-tools.git](https://github.com/zendexzen/xubuntu-sysadmin-tools.git)
   cd xubuntu-sysadmin-tools

Segurança: Todos os scripts de automação estão configurados com permissões 700
 para garantir que apenas o utilizador autenticado tenha privilégios de execução e leitura,
 mitigando riscos de escalada de privilégios local...

1. Configurar permissões de segurança (Nível 700):
chmod 700 *.sh

Modo Direto (Recomendado):
./dark-rose-monitor.sh

Modo Background (Para manter o monitor ativo):
nohup ./dark-rose-monitor.sh &


Utilizamos chmod 700 para garantir que apenas o proprietário do ficheiro tenha permissões de Leitura (r), Escrita (w) e Execução (x). 
Em ambientes de servidores como o M58p,
isto impede que outros utilizadores ou processos não autorizados visualizem a lógica dos scripts ou tentem executá-los.
