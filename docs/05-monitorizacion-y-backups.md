# Fase 5 · Monitorización y copias de seguridad

## Objetivo
Saber qué está pasando en la infraestructura (y que te avise), y poder recuperarla. Una copia que no has restaurado no es una copia.

## Parte A · Monitorización con Zabbix

### 1. Instalar Zabbix en `srv-mon`
Sigue la guía oficial de zabbix.com/download: elige tu versión de Zabbix, **Ubuntu** y tu versión, **Server + Frontend + Agent**, base de datos MySQL o PostgreSQL y servidor web Nginx. Así evitas copiar comandos de una versión antigua. Asigna 2 GB de RAM a la VM.

### 2. Alta de equipos
- Linux: se instala el agente con el playbook de Ansible de la fase 6; hasta entonces, a mano (`sudo apt install zabbix-agent`, `Server=192.168.20.20`, `Hostname=srv-web`).
- Windows: instala el agente de Zabbix (MSI) en `dc01` y `cli-win01`.
- En el frontend: Datos de recogida → Equipos → Crear equipo, con plantillas `Linux by Zabbix agent` y `Windows by Zabbix agent`.
- Abre en fw01 el puerto TCP 10050 de `srv-mon` hacia los agentes y el 10051 hacia el servidor si usas agente activo.

### 3. Qué vigilar
- CPU, RAM, disco, uptime de cada servidor.
- Servicios: nginx, AD DS, DNS, DHCP.
- Certificado HTTPS (días hasta que caduca).
- Disponibilidad de fw01 (ICMP o SNMP).

### 4. Alertas
- Configura un **tipo de medio** (correo SMTP o **Telegram**; las versiones recientes de Zabbix traen la plantilla de Telegram) y una acción para enviar avisos de problemas de gravedad Alta o superior.
- Crea un bot con @BotFather en Telegram si eliges esa vía.
- **Prueba la alerta**: apaga nginx (`sudo systemctl stop nginx`) y comprueba que llega el aviso y que se recupera después.

### 5. Dashboard
Crea un panel con estado de equipos, problemas activos y gráficos clave. Captura de pantalla para el README.

## Parte B · Copias de seguridad

### Política (regla 3-2-1)
3 copias, en 2 soportes distintos, 1 fuera de ubicación. En el laboratorio: datos originales, copia local en otro disco/VM y copia en el anfitrión o en la nube.

| Qué | Cómo | Frecuencia | Retención |
|---|---|---|---|
| Ficheros de `srv-web` | [`scripts/backup.sh`](../scripts/backup.sh) por cron | Diaria | 14 días |
| Estado del sistema de `dc01` | Windows Server Backup (`wbadmin`) | Diaria | 7 copias |
| Datos compartidos | Windows Server Backup o Veeam Agent Free | Diaria | 7 copias |
| Configuración de fw01 | Descarga manual / plugin de backup | Tras cada cambio | Las últimas 10 |
| VMs completas | Exportar OVA en el anfitrión | Tras cada fase | Las de fases cerradas |

### Cron en `srv-web`
```bash
sudo crontab -e
# Todos los días a las 02:30
30 2 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
```

### Pruebas de restauración (obligatorias)
1. **Fichero:** borra `/var/www/html/index.html` y restáuralo desde el backup. Mide el tiempo.
2. **Active Directory:** borra un usuario y recupéralo desde la Papelera de AD.
3. **Carpeta compartida:** restaura una versión anterior desde la copia.
4. **(Avanzado)** Restauración del estado del sistema del DC.

Registra cada prueba: qué se hizo, cuánto tardó y si hubo problemas.

## Comprobaciones
- [ ] Zabbix muestra todos los equipos en verde
- [ ] Llegó una alerta real (apagando un servicio) y su recuperación
- [ ] Backup automático ejecutado por cron con rotación
- [ ] Al menos dos pruebas de restauración con tiempos anotados

## Qué documentar
- Dashboard, alerta recibida, historial del backup y pruebas de restauración.
- Política de copias en una tabla en el README.

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| Agente "no disponible" | Firewall (fw01 o UFW) o `Server=` mal puesto |
| No llegan alertas | Usuario de Zabbix sin medio configurado o acción deshabilitada |
| Cron no ejecuta el script | Ruta, permisos (`chmod +x`) o falta de `PATH` |

## Resultado (rellena al terminar)
