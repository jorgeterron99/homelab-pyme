# Cómo presentar el proyecto

## En el CV (sección "Proyectos")
**Homelab de infraestructura para pyme** · github.com/TU_USUARIO/homelab-pyme
- Diseñé e implanté una red segmentada en 4 zonas (usuarios, servidores, invitados, DMZ) con firewall OPNsense, reglas de mínimo privilegio y acceso remoto por WireGuard.
- Desplegué Active Directory (DNS, DHCP, GPO, permisos NTFS) y automaticé altas de usuarios con PowerShell.
- Automaticé la configuración de servidores Linux con Ansible (idempotente) y validación continua con GitHub Actions.
- Implementé monitorización con Zabbix y alertas por Telegram; política de copias 3-2-1 con restauraciones probadas.
- Documenté diagramas, direccionamiento, pruebas e incidencias en GitHub.

Adapta los verbos y las cifras a lo que realmente hayas hecho. No escribas nada que no sepas defender.

## En LinkedIn
Publica un breve texto al terminar (qué has montado, qué has aprendido, enlace al repo y una captura del diagrama o del dashboard). Añade las tecnologías en "Aptitudes" y el repositorio en "Destacados".

## Preguntas típicas de entrevista (prepara respuesta)
1. ¿Por qué segmentaste la red así? ¿Qué pasaría si comprometen la DMZ?
2. ¿Cómo funciona DHCP relay y por qué lo usaste?
3. Explica qué ocurre cuando un cliente se une al dominio (DNS, Kerberos, LDAP).
4. ¿Qué es la idempotencia en Ansible? ¿Cómo la comprobaste?
5. ¿Cómo garantizas que tus copias de seguridad sirven?
6. Cuéntame el problema más difícil que tuviste y cómo lo diagnosticaste.
7. ¿Qué mejorarías si fuera una pyme real? (alta disponibilidad, segundo DC, IDS, MFA, logs centralizados…)

## Dónde buscar con este perfil
- Portales de empleo: InfoJobs, LinkedIn, Indeed, Tecnoempleo y portales de empleo público.
- Empresas de servicios gestionados (MSP) y consultoras con soporte remoto, para teletrabajo.
- Pymes y consultoras de tu zona (Extremadura): contacto directo con el repositorio como carta de presentación.
- Empleo público: convocatorias de técnicos de informática de ayuntamientos, Junta y otras administraciones.
- Prácticas y bolsas de empleo de tu centro de formación.
