# Homelab pyme: red y sistemas virtualizados

Infraestructura completa de una pequeña empresa (firewall, zonas de red, Active Directory, servidores Linux, VPN, monitorización, copias de seguridad y automatización) montada en un portátil con virtualización y documentada paso a paso.

> **Plantilla:** cuando termines cada fase, rellena la sección "Resultado" de su documento y actualiza la tabla de estado de este README. Al final, este README es tu carta de presentación: bórrame las instrucciones y deja solo lo que has conseguido.

## Objetivo

Demostrar capacidad real en administración de sistemas y redes: diseñar, implantar, asegurar, monitorizar, automatizar y documentar.

## Arquitectura

Diagrama completo en [`docs/diagrama-red.md`](docs/diagrama-red.md).

| Zona | VLAN ID | Red | Contenido |
|---|---|---|---|
| Usuarios | 10 | 192.168.10.0/24 | Clientes Windows/Linux |
| Servidores | 20 | 192.168.20.0/24 | Active Directory, monitorización, Ansible |
| Invitados | 30 | 192.168.30.0/24 | Solo Internet |
| DMZ | 40 | 192.168.40.0/24 | Servidor web / Nextcloud |
| VPN | - | 10.10.10.0/24 | Túnel WireGuard |

## Tecnologías

OPNsense · Windows Server 2022 (AD DS, DHCP, DNS, GPO) · Ubuntu Server · Nginx · Zabbix · WireGuard · Ansible · Bash · PowerShell · Python · GitHub Actions

## Estado del proyecto

| Fase | Contenido | Estado |
|---|---|---|
| 0 | [Preparación del entorno](docs/00-preparacion.md) | [ ] |
| 1 | [Firewall OPNsense y primer cliente](docs/01-opnsense-base.md) | [ ] |
| 2 | [Zonas (VLAN) y reglas de firewall](docs/02-zonas-y-firewall.md) | [ ] |
| 3 | [Active Directory, DHCP, DNS, GPO](docs/03-active-directory.md) | [ ] |
| 4 | [Servidores Linux: web con HTTPS](docs/04-servidores-linux.md) | [ ] |
| 5 | [Monitorización y copias de seguridad](docs/05-monitorizacion-y-backups.md) | [ ] |
| 6 | [Automatización con Ansible y CI](docs/06-automatizacion.md) | [ ] |
| 7 | [VPN con WireGuard](docs/07-vpn-wireguard.md) | [ ] |
| 8 | [Cierre: documentación y portfolio](docs/08-cierre-y-portfolio.md) | [ ] |

## Estructura del repositorio

```
docs/         Guía por fases, direccionamiento, diagrama, plan de estudio
ansible/      Inventario, playbooks y plantillas
scripts/      Bash, PowerShell y Python de apoyo
evidencias/   Capturas y salidas de comandos (organizadas por fase)
.github/      Pipeline de validación (ansible-lint, shellcheck)
```

## Cómo seguir esta guía

1. Lee [`docs/00-preparacion.md`](docs/00-preparacion.md) y prepara el entorno.
2. Mira el [plan de estudio](docs/plan-de-estudio.md) para repartir el tiempo.
3. Haz las fases en orden. Cada una tiene: objetivo, pasos, comprobaciones, qué documentar y problemas típicos.
4. Haz una captura o guarda la salida de cada comprobación en `evidencias/faseN/`.
5. Sube a GitHub al terminar cada fase (commit pequeño y con mensaje claro).
6. Anota los problemas que te encuentres en [`docs/registro-incidencias.md`](docs/registro-incidencias.md). A los entrevistadores les interesa más cómo resuelves fallos que un montaje perfecto.

## Licencia

Uso educativo. Las contraseñas y datos de este repositorio son de laboratorio; no subas nunca credenciales reales.
