# Fase 4 · Servidores Linux: web con HTTPS

## Objetivo
Un servidor web en la DMZ con HTTPS, endurecido, accesible desde usuarios y no desde invitados; y la base de `srv-mon` para las fases siguientes.

## 1. Crear `srv-web`
- Ubuntu Server LTS **sin entorno gráfico**, 1 GB de RAM, red interna `lan-dmz`.
- Usuario administrador `admin`. Activa OpenSSH en la instalación.
- IP estática por netplan (`/etc/netplan/50-cloud-init.yaml` o similar; el nombre de la interfaz puede variar):
```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      addresses: [192.168.40.10/24]
      routes:
        - to: default
          via: 192.168.40.1
      nameservers:
        addresses: [192.168.20.10, 192.168.40.1]
```
```bash
sudo netplan apply
```

## 2. Crear `srv-mon`
Misma base, red `lan-servidores`, IP `192.168.20.20/24`, puerta de enlace `192.168.20.1`. Se usará en la fase 5 (Zabbix) y 6 (Ansible).

## 3. Registro DNS
En `dc01` (DNS) crea registros A: `srv-web.pyme.lan → 192.168.40.10` y `srv-mon.pyme.lan → 192.168.20.20`.

## 4. Nginx con HTTPS (a mano la primera vez)
```bash
sudo apt update && sudo apt install -y nginx openssl
sudo mkdir -p /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/srv-web.key -out /etc/nginx/ssl/srv-web.crt \
  -subj "/CN=srv-web.pyme.lan"
```
Configura un `server` en el puerto 443 con ese certificado y redirige el 80 al 443 (tienes un ejemplo en `ansible/playbooks/templates/nginx-site.conf.j2`).

> Hacerlo a mano primero es intencional: en la fase 6 lo automatizarás y entenderás qué hace cada tarea.

**Mejora opcional:** en lugar de un certificado autofirmado, monta una CA interna con **AD CS** en `dc01`, emite el certificado y distribúyelo por GPO para que los clientes no vean advertencias.

## 5. Endurecimiento básico
- Cortafuegos del host:
```bash
sudo ufw default deny incoming
sudo ufw allow from 192.168.20.20 to any port 22 proto tcp
sudo ufw allow 80,443/tcp
sudo ufw enable
```
- SSH solo con clave (genera una con `ssh-keygen -t ed25519`, cópiala con `ssh-copy-id` y **solo entonces** desactiva `PasswordAuthentication`). Prueba en otra sesión antes de cerrar la actual.
- `PermitRootLogin no`.
- `fail2ban` instalado y activo.
- Actualizaciones de seguridad automáticas: `sudo apt install unattended-upgrades`.
- Sincronización horaria: `chrony`.

## 6. Extensión opcional: Nextcloud en Docker
Si quieres sumar contenedores al currículum, instala Docker en `srv-web` y despliega Nextcloud con `docker compose` detrás de Nginx como proxy inverso. Es un buen añadido, pero solo cuando todo lo anterior funcione.

## Comprobaciones
- [ ] `https://srv-web.pyme.lan` carga desde un cliente de usuarios
- [ ] El puerto 80 redirige a 443
- [ ] Un invitado no llega a `srv-web`
- [ ] `srv-web` no puede conectar a la red de servidores (prueba con `nc`)
- [ ] SSH solo por clave y solo desde `srv-mon`

## Qué documentar
- Captura de la web con el certificado.
- Salida de `ss -tulpn`, `ufw status verbose`, `nmap` desde otra zona.
- Fichero de configuración de nginx.

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| No resuelve el nombre | Falta el registro A en el DNS de dc01 |
| Timeout al conectar | Regla de fw01 o UFW |
| Te dejas fuera por SSH | Desactivaste contraseñas sin comprobar la clave. Recupera con la consola de la VM |

## Resultado (rellena al terminar)
