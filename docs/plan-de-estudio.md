# Plan de estudio y calendario

Calendario orientativo para **6-8 horas semanales** (unas 12 semanas). Si dispones de más tiempo, comprime; si tienes menos, alarga. Lo importante es la constancia y subir cambios a GitHub cada semana.

| Semana | Fase | Aprender | Entregable en el repo |
|---|---|---|---|
| 1 | 0 | Git básico, virtualización, repaso de TCP/IP y subnetting | Repo creado, VMs base |
| 2 | 1 | Funcionamiento de un firewall/NAT, DHCP, DNS | Cliente con Internet tras OPNsense |
| 3-4 | 2 | VLANs, ACLs, alias, política de mínimo privilegio | Matriz de pruebas completa |
| 5-6 | 3 | AD DS, DNS integrado, DHCP, GPO, permisos NTFS | Dominio funcionando + scripts PowerShell |
| 7 | 4 | Linux: servicios, SSH, UFW, nginx, TLS | Web HTTPS en DMZ |
| 8 | 5 | Zabbix, alertas, política 3-2-1 | Dashboard y alerta real |
| 8 | 5 | Backups y restauración | Pruebas documentadas |
| 9-10 | 6 | Ansible, idempotencia, Git en equipo, CI | Playbooks + Action en verde |
| 11 | 7 | WireGuard, rutas, AllowedIPs | Túnel operativo |
| 12 | 8 | Documentar y pulir | README final, CV y LinkedIn |

## Bloques de estudio recomendados (en paralelo)
1. **Linux:** comandos, permisos, systemd, redes, journald, cron, bash. Objetivo: LPIC-1 o RHCSA.
2. **Redes:** modelo OSI/TCP-IP, subnetting, VLANs, enrutamiento, NAT, ACL. Objetivo: CCNA.
3. **Windows Server:** AD, GPO, DNS, DHCP, PowerShell.
4. **Cloud (ligero):** AZ-900 o AWS Cloud Practitioner para tener la base.

## Recursos orientativos
- Documentación oficial: OPNsense, Microsoft Learn, Ansible, Zabbix, WireGuard. Es de lo mejor que hay y gratuita.
- Cisco Networking Academy (cursos de redes gratuitos).
- Microsoft Learn (rutas de AZ-900 y Windows Server).
- Fortinet Training Institute (cursos NSE iniciales gratuitos).
- Canal y comunidad de r/homelab, r/sysadmin para ideas y problemas reales.

## Hábito semanal
- 1 commit mínimo por sesión.
- Una entrada en el registro de incidencias por problema resuelto.
- Un snapshot por fase terminada.
