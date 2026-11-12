#!/usr/bin/env bash
# Copia de seguridad con rotación.
# Uso: sudo ./backup.sh
# Edita las variables de la sección CONFIGURACIÓN.
set -euo pipefail

# --- CONFIGURACIÓN ---
ORIGENES=(/etc /var/www /home)
DESTINO="/backup"
RETENCION_DIAS=14
# Copia remota opcional (descomenta y ajusta):
# REMOTO="admin@192.168.20.20:/backup/$(hostname)/"
# ---------------------

FECHA="$(date +%Y%m%d-%H%M%S)"
ARCHIVO="${DESTINO}/backup-$(hostname)-${FECHA}.tar.gz"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*"
}

mkdir -p "$DESTINO"

log "Inicio de copia -> $ARCHIVO"
tar -czf "$ARCHIVO" "${ORIGENES[@]}"
sha256sum "$ARCHIVO" > "${ARCHIVO}.sha256"
log "Copia creada ($(du -h "$ARCHIVO" | cut -f1))"

log "Eliminando copias de más de ${RETENCION_DIAS} días"
find "$DESTINO" -name 'backup-*' -type f -mtime +"$RETENCION_DIAS" -delete

if [ -n "${REMOTO:-}" ]; then
    log "Sincronizando con $REMOTO"
    rsync -az --delete "$DESTINO"/ "$REMOTO"
fi

log "Fin de copia"
