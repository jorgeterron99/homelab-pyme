# Diagrama de red

GitHub renderiza este diagrama automáticamente. Cuando termines, exporta también una versión en imagen (por ejemplo con draw.io) y guárdala en `evidencias/`.

```mermaid
flowchart TB
    NET((Internet)) --- FW["fw01 OPNsense<br/>Firewall / Router / VPN"]
    FW --- U["Usuarios VLAN 10<br/>192.168.10.0/24"]
    FW --- S["Servidores VLAN 20<br/>192.168.20.0/24"]
    FW --- G["Invitados VLAN 30<br/>192.168.30.0/24"]
    FW --- D["DMZ VLAN 40<br/>192.168.40.0/24"]
    FW -.- V["VPN WireGuard<br/>10.10.10.0/24"]
    U --- C1["cli-win01"]
    U --- C2["cli-linux01"]
    S --- DC["dc01 AD DS DNS DHCP<br/>192.168.20.10"]
    S --- MON["srv-mon Zabbix Ansible<br/>192.168.20.20"]
    D --- WEB["srv-web Nginx<br/>192.168.40.10"]
    G --- GU["Dispositivos de invitados"]
    V -.- REM["Portátil remoto"]
```

## Flujos permitidos (resumen)
| Origen | Destino | Servicio |
|---|---|---|
| Usuarios | dc01 | DNS, Kerberos, LDAP, SMB |
| Usuarios | srv-web | HTTPS |
| Usuarios | Internet | Todo |
| Servidores | Internet | HTTP/HTTPS (actualizaciones) |
| srv-mon | srv-web / dc01 | SSH, agente Zabbix |
| Invitados | Internet | Todo (aislados del resto) |
| DMZ | Internet | HTTP/HTTPS (actualizaciones) |
| VPN | Usuarios, Servidores | Solo lo necesario |
