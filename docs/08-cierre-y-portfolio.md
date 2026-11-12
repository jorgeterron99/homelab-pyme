# Fase 8 · Cierre: documentación y portfolio

## Objetivo
Convertir el laboratorio en algo que un reclutador pueda entender en dos minutos.

## 1. Revisión del repositorio
- [ ] README con descripción, diagrama, tabla de zonas y estado de fases
- [ ] Diagrama de red actualizado ([`diagrama-red.md`](diagrama-red.md))
- [ ] Tabla de direccionamiento y equipos al día ([`direccionamiento.md`](direccionamiento.md))
- [ ] Capturas organizadas en `evidencias/faseN/`
- [ ] Sin contraseñas, claves privadas ni ficheros de configuración sensibles (usa `git log -p` y `grep -ri "password\|secret\|private"` para revisar)
- [ ] Badge de la Action en el README
- [ ] Registro de incidencias con al menos 5 casos resueltos

## 2. Pruebas de cierre
- Apaga `srv-web` y comprueba que Zabbix avisa.
- Restaura un fichero y un usuario de AD desde copia.
- Reconstruye `srv-web` desde cero con Ansible: tiempo y resultado.
- Pasa un `nmap` desde invitados y desde DMZ y documenta lo que se ve.

## 3. Mejoras (cada una puede ser un commit)
- Roles de Ansible y Vault.
- Certificados desde AD CS.
- Syslog centralizado (rsyslog o Graylog).
- IDS/IPS en OPNsense (Suricata).
- Segundo controlador de dominio.
- Nextcloud en Docker con proxy inverso.
- Informe automático de estado con el script Python.

## 4. Cómo presentarlo
Consulta [`como-presentarlo.md`](como-presentarlo.md): texto para el CV, para LinkedIn y respuestas para entrevistas.

## Resultado final
_Resumen en cinco líneas de lo que has construido y aprendido._
