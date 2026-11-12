# Plan de direccionamiento

## Redes
| Zona | VLAN ID | Red | Puerta de enlace | DHCP |
|---|---|---|---|---|
| Usuarios | 10 | 192.168.10.0/24 | 192.168.10.1 | .100-.200 (dc01 tras fase 3) |
| Servidores | 20 | 192.168.20.0/24 | 192.168.20.1 | No (IP estática) |
| Invitados | 30 | 192.168.30.0/24 | 192.168.30.1 | .100-.200 (fw01) |
| DMZ | 40 | 192.168.40.0/24 | 192.168.40.1 | No (IP estática) |
| VPN acceso remoto | - | 10.10.10.0/24 | 10.10.10.1 | No |
| Sede 2 (opcional) | - | 192.168.50.0/24 | 192.168.50.1 | - |
| Túnel sede a sede (opcional) | - | 10.10.20.0/24 | - | - |

## Equipos
| Nombre | Rol | Zona | IP | SO | Servicios |
|---|---|---|---|---|---|
| fw01 | Firewall, router, VPN | todas | .1 en cada zona | OPNsense | Firewall, DHCP relay, WireGuard |
| dc01 | Controlador de dominio | Servidores | 192.168.20.10 | Windows Server 2022 | AD DS, DNS, DHCP, ficheros |
| srv-mon | Monitorización y Ansible | Servidores | 192.168.20.20 | Ubuntu Server | Zabbix, Ansible |
| srv-web | Web | DMZ | 192.168.40.10 | Ubuntu Server | Nginx (y Nextcloud opcional) |
| cli-win01 | Cliente de dominio | Usuarios | DHCP | Windows 10/11 | - |
| cli-linux01 | Cliente de pruebas | Usuarios | DHCP | Lubuntu/Mint | - |

## Dominio y nombres
- Dominio AD: `pyme.lan` (NetBIOS `PYME`)
- Registros: `dc01`, `srv-web`, `srv-mon` en `pyme.lan`

## Notas
Rellena este fichero según vayas montando y mantén los datos al día. Un plan de direccionamiento actualizado es de lo primero que pide un responsable técnico.
