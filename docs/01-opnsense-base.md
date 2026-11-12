# Fase 1 · Firewall OPNsense y primer cliente

## Objetivo
Un firewall/router funcionando con salida a Internet y un cliente detrás que obtiene IP por DHCP.

## Esquema
```
Internet ── [NAT del hipervisor] ── WAN fw01 LAN ── red "lan-usuarios" ── cli-linux01
                                          192.168.10.1/24
```

## 1. Crear la VM fw01
- Tipo: BSD / FreeBSD 64-bit. 1 CPU, 1-2 GB de RAM, disco de 16 GB.
- **Adaptador 1:** NAT (será la WAN).
- **Adaptador 2:** Red interna, nombre `lan-usuarios` (será la LAN).
- Tipo de adaptador: Intel PRO/1000 (en VirtualBox da menos problemas).
- La imagen `dvd` de OPNsense viene comprimida (.bz2): descomprímela con 7-Zip antes de montarla.

## 2. Instalar
1. Arranca la ISO. En la pantalla de login entra con usuario `installer` y contraseña `opnsense` para lanzar el instalador.
2. Elige el disco, sistema de ficheros (UFS o ZFS, ambos valen) y define la **contraseña de root**.
3. Reinicia y **desmonta la ISO**.

## 3. Configuración por consola
En el menú de consola:
- Opción **1 (Assign interfaces)**: WAN = primer adaptador (NAT), LAN = segundo.
- Opción **2 (Set interface IP address)**: LAN = `192.168.10.1/24`, activa DHCP con rango `192.168.10.100 - 192.168.10.200`.

## 4. Cliente
Crea `cli-linux01` (Lubuntu o Mint) en la red interna `lan-usuarios`. Debe recibir IP `192.168.10.x`.

## 5. Configuración web
Desde el cliente abre `https://192.168.10.1` (usuario `root`).
- Asistente inicial (System → Wizard): hostname `fw01`, dominio `pyme.lan`, DNS 1.1.1.1 y 9.9.9.9.
- **Gotcha típico:** en Interfaces → WAN, desmarca **Block private networks**. Con NAT del hipervisor la WAN tiene IP privada (10.0.2.x) y, si no lo desmarcas, no sale tráfico.
- Cambia la zona horaria (System → Settings → General) a Europe/Madrid.
- Haz una copia de la configuración: System → Configuration → Backups → Download. Guárdala en `evidencias/fase1/` **sin subirla a GitHub** si contiene contraseñas (revisa antes).

> Los menús de OPNsense cambian entre versiones (el servidor DHCP puede ser ISC, Dnsmasq o Kea). Si no encuentras algo, busca el nombre en la caja de búsqueda superior de la interfaz.

## Comprobaciones
- [ ] `cli-linux01` obtiene IP 192.168.10.x por DHCP
- [ ] `ping 192.168.10.1` responde
- [ ] `ping 1.1.1.1` responde (salida a Internet)
- [ ] `ping google.com` resuelve (DNS)
- [ ] Puedes entrar a la GUI desde el cliente

## Qué documentar
- Captura del dashboard de OPNsense con las interfaces.
- Salida de `ip a`, `ping` y `nslookup` del cliente.
- Tabla de direccionamiento actualizada en [`direccionamiento.md`](direccionamiento.md).

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| El cliente no recibe IP | La red interna tiene nombres distintos en cada VM; el DHCP no está activado en LAN |
| Hay IP pero no hay Internet | "Block private networks" marcado en WAN; falta NAT outbound automático |
| No carga la GUI | Estás entrando desde la red WAN, que está bloqueada por defecto |

## Resultado (rellena al terminar)
_Qué has montado, qué ha fallado y cómo lo resolviste._
