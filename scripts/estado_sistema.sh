#!/usr/bin/env bash
# Informe rápido del estado de un servidor Linux.
# Uso: ./estado_sistema.sh [servicio1 servicio2 ...]
# Devuelve código 1 si algún servicio indicado no está activo.
set -uo pipefail

SERVICIOS=("$@")
if [ "${#SERVICIOS[@]}" -eq 0 ]; then
    SERVICIOS=(ssh)
fi

echo "=== Estado de $(hostname) · $(date '+%Y-%m-%d %H:%M:%S') ==="
echo
echo "--- Uptime y carga ---"
uptime -p
cut -d' ' -f1-3 /proc/loadavg

echo
echo "--- Memoria ---"
free -h | awk 'NR==1 || /^Mem:/ || /^Swap:/'

echo
echo "--- Disco ---"
df -h --output=source,size,used,pcent,target -x tmpfs -x devtmpfs | head -n 10

echo
echo "--- Red ---"
ip -brief address | grep -v '^lo'

echo
echo "--- Servicios ---"
fallos=0
for servicio in "${SERVICIOS[@]}"; do
    if systemctl is-active --quiet "$servicio"; then
        echo "OK     $servicio"
    else
        echo "FALLO  $servicio"
        fallos=$((fallos + 1))
    fi
done

echo
echo "--- Últimos accesos fallidos por SSH ---"
journalctl -u ssh --since "24 hours ago" --no-pager 2>/dev/null | grep -c "Failed password" || true

if [ "$fallos" -gt 0 ]; then
    exit 1
fi
