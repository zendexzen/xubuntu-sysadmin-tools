#!/bin/bash
echo "--- NETWORK DIAGNOSTICS ---"
echo "IP Local: $(hostname -I)"
echo "Estado Tailscale: $(tailscale status | head -n 1)"
echo "Ping Google (Latência): $(ping -c 1 8.8.8.8 | grep 'time=' | awk '{print $7}')"
