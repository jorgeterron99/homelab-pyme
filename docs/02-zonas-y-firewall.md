# Fase 2 · Zonas (VLAN) y reglas de firewall

## Objetivo
Segmentar la red en zonas y aplicar una política de mínimo privilegio con reglas bien pensadas y probadas.

## Zonas
| Interfaz OPNsense | Red interna del hipervisor | VLAN ID de referencia | IP del firewall |
|---|---|---|---|
| LAN (usuarios) | `lan-usuarios` | 10 | 192.168.10.1/24 |
| SERVIDORES | `lan-servidores` | 20 | 192.168.20.1/24 |
| INVITADOS | `lan-invitados` | 30 | 192.168.30.1/24 |
| DMZ | `lan-dmz` | 40 | 192.168.40.1/24 |

### Sobre las "VLAN" en el laboratorio
En un entorno virtual de portátil, lo más sencillo es crear **una red interna por zona** y darle una interfaz a fw01 en cada una. Lógicamente es lo mismo que tener VLANs en un switch: segmentos separados que solo se comunican a través del firewall. Los IDs 10/20/30/40 quedan como plan de diseño para el mundo real.

**Ampliación (opcional):** configura VLANs 802.1Q reales con una sola interfaz troncal en OPNsense (Interfaces → Other Types → VLAN) y etiqueta el tráfico en un cliente Linux con `ip link add link enp0s3 name enp0s3.10 type vlan id 10`. Que el hipervisor deje pasar las tramas etiquetadas depende del producto y la versión; si lo consigues, documenta cómo.

## 1. Añadir adaptadores
En VirtualBox, adaptadores 1 a 4: NAT, `lan-usuarios`, `lan-servidores`, `lan-dmz`. El quinto (invitados) se añade con la VM apagada:
```bash
VBoxManage modifyvm "fw01" --nic5 intnet --intnet5 "lan-invitados" --nictype5 82540EM
```
En VMware, añade adaptadores "LAN Segment".

## 2. Asignar y configurar interfaces en OPNsense
Interfaces → Assignments → añade cada nuevo adaptador, actívalo, ponle IPv4 estática y un nombre descriptivo (SERVIDORES, DMZ, INVITADOS). Activa DHCP en INVITADOS (192.168.30.100-200) y en DMZ si quieres.

## 3. Alias (Firewall → Aliases)
| Alias | Tipo | Contenido |
|---|---|---|
| `RED_PRIVADA` | Red(es) | 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 |
| `PUERTOS_AD` | Puerto(s) | 53, 88, 123, 135, 389, 445, 464, 636, 3268, 3269, 49152:65535 |
| `PUERTOS_WEB` | Puerto(s) | 80, 443 |
| `HOST_DC01` | Host(s) | 192.168.20.10 |
| `HOST_WEB` | Host(s) | 192.168.40.10 |

## 4. Reglas (política: todo denegado salvo lo permitido)
Las reglas se evalúan de arriba abajo en cada interfaz y gana la primera que coincide.

### LAN (Usuarios)
| Acción | Destino | Puertos | Motivo |
|---|---|---|---|
| Permitir | HOST_DC01 | PUERTOS_AD (TCP/UDP) | Dominio, DNS, Kerberos, ficheros |
| Permitir | HOST_WEB | PUERTOS_WEB | Acceso a la web |
| Permitir | This Firewall | 53 | DNS (hasta que el DC lo sustituya) |
| Bloquear | RED_PRIVADA | cualquiera | No acceder al resto de zonas |
| Permitir | cualquiera | cualquiera | Internet |

### SERVIDORES
| Acción | Destino | Puertos | Motivo |
|---|---|---|---|
| Permitir | This Firewall | 53, 123 | DNS y NTP |
| Bloquear | LAN y INVITADOS (red) | cualquiera | Los servidores no inician hacia clientes |
| Permitir | cualquiera | 80, 443 | Actualizaciones |
| Permitir | HOST_WEB | 22 | Administración (Ansible/SSH) desde `srv-mon` |

### INVITADOS
| Acción | Destino | Puertos | Motivo |
|---|---|---|---|
| Permitir | This Firewall | 53 | DNS |
| Bloquear | RED_PRIVADA | cualquiera | Aislamiento total |
| Permitir | cualquiera | cualquiera | Solo Internet |

### DMZ
| Acción | Destino | Puertos | Motivo |
|---|---|---|---|
| Permitir | This Firewall | 53, 123 | DNS y NTP |
| Bloquear | RED_PRIVADA | cualquiera | Si comprometen la DMZ, no pueden ir a la red interna |
| Permitir | cualquiera | 80, 443 | Actualizaciones |

Activa el log en las reglas de bloqueo (Firewall → Log Files → Live View) para ver qué deniega.

## 5. Matriz de pruebas
Rellena esta tabla con el resultado real (`OK` = como se espera):

| Origen | Destino | Esperado | Resultado |
|---|---|---|---|
| Usuarios | Internet | Permitido | |
| Usuarios | srv-web:443 | Permitido | |
| Usuarios | srv-web:22 | Bloqueado | |
| Usuarios | Invitados | Bloqueado | |
| Invitados | Internet | Permitido | |
| Invitados | Usuarios | Bloqueado | |
| Invitados | Servidores | Bloqueado | |
| DMZ | Servidores | Bloqueado | |
| DMZ | Internet:443 | Permitido | |
| Servidores | Internet:443 | Permitido | |

Herramientas: `ping`, `nc -zv IP PUERTO`, `curl -k https://IP`, `nmap -Pn IP`.

## Comprobaciones
- [ ] Las cuatro zonas están creadas con IP del firewall
- [ ] Alias y reglas aplicadas
- [ ] Matriz de pruebas completa
- [ ] Copia de seguridad de la configuración de OPNsense

## Qué documentar
- Captura de cada pestaña de reglas.
- Matriz de pruebas con las capturas de los bloqueos en el Live View.
- Actualiza [`direccionamiento.md`](direccionamiento.md).

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| Una regla "no funciona" | Hay otra más arriba que coincide antes; revisa el orden |
| Bloqueas y sigue pasando | Sesiones ya establecidas; Firewall → Diagnostics → States → resetea |
| Los invitados llegan a la red interna | La regla de bloqueo a `RED_PRIVADA` está debajo de "permitir todo" |

## Resultado (rellena al terminar)
