#!/usr/bin/env python3
"""Comprueba servicios clave del laboratorio y genera una tabla Markdown.

Uso:
    python3 informe_red.py > informe.md

Solo usa la biblioteca estándar. Ajusta la lista HOSTS a tu red.
Ideas para ampliarlo: guardar el informe con fecha, enviarlo por Telegram,
programarlo con cron o comparar con el informe anterior.
"""
import socket
from datetime import datetime

# nombre: (ip, [(puerto, servicio), ...])
HOSTS = {
    "fw01": ("192.168.10.1", [(443, "GUI OPNsense")]),
    "dc01": ("192.168.20.10", [(53, "DNS"), (389, "LDAP"), (445, "SMB")]),
    "srv-mon": ("192.168.20.20", [(22, "SSH"), (80, "Zabbix web")]),
    "srv-web": ("192.168.40.10", [(80, "HTTP"), (443, "HTTPS")]),
}
TIMEOUT = 2


def puerto_abierto(ip: str, puerto: int) -> bool:
    try:
        with socket.create_connection((ip, puerto), timeout=TIMEOUT):
            return True
    except OSError:
        return False


def main() -> None:
    print(f"# Informe de estado · {datetime.now():%Y-%m-%d %H:%M}\n")
    print("| Equipo | IP | Servicio | Puerto | Estado |")
    print("|---|---|---|---|---|")
    caidos = 0
    for nombre, (ip, servicios) in HOSTS.items():
        for puerto, servicio in servicios:
            ok = puerto_abierto(ip, puerto)
            if not ok:
                caidos += 1
            estado = "OK" if ok else "CAÍDO"
            print(f"| {nombre} | {ip} | {servicio} | {puerto} | {estado} |")
    print(f"\n**Servicios caídos:** {caidos}")


if __name__ == "__main__":
    main()
