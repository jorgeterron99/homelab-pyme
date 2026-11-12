# Fase 3 · Active Directory, DHCP, DNS y GPO

## Objetivo
Un dominio `pyme.lan` con usuarios, grupos, directivas, carpetas compartidas, DHCP y DNS propios, y un cliente Windows unido al dominio.

## 1. Preparar dc01
- VM Windows Server 2022 con escritorio, 3 GB de RAM, red interna `lan-servidores`.
- Nombre: `DC01`. IP estática: `192.168.20.10/24`, puerta de enlace `192.168.20.1`, DNS: `127.0.0.1` (ya apuntará a sí mismo).
- Zona horaria y teclado en español. Instala las actualizaciones.

## 2. Instalar AD DS y crear el dominio
Administrador del servidor → Agregar roles → **Servicios de dominio de Active Directory** (incluye DNS). Después "Promocionar este servidor a controlador de dominio":
- Nuevo bosque: `pyme.lan`
- Contraseña de modo de restauración (DSRM): anótala en tu gestor de contraseñas.
- Tras reiniciar, en DNS configura **reenviadores** a `192.168.20.1` (fw01).

PowerShell equivalente:
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "pyme.lan" -DomainNetbiosName "PYME" -InstallDns
```

## 3. Estructura del dominio
Ejecuta [`scripts/crear_estructura_ad.ps1`](../scripts/crear_estructura_ad.ps1) para crear OUs y grupos:
```
pyme.lan
├── Usuarios
│   ├── Direccion
│   ├── Administracion
│   ├── Ventas
│   └── IT
├── Equipos
└── Grupos
```
Después da de alta usuarios de prueba con [`scripts/alta_usuarios_ad.ps1`](../scripts/alta_usuarios_ad.ps1) y [`scripts/usuarios.csv`](../scripts/usuarios.csv).

Activa la **Papelera de reciclaje de AD** (Centro de administración de Active Directory). La usarás en la fase 5.

## 4. DHCP en dc01
1. Instala el rol **Servidor DHCP** y autorízalo.
2. Crea un ámbito para usuarios: `192.168.10.100 - 192.168.10.200`, máscara /24.
3. Opciones: 003 router `192.168.10.1`, 006 DNS `192.168.20.10`, 015 dominio `pyme.lan`.
4. En OPNsense, **desactiva el DHCP de la interfaz LAN** y activa un **DHCP Relay** (Services → DHCRelay; el nombre exacto varía según la versión) apuntando a `192.168.20.10`.
5. Abre en el firewall lo necesario para el relay (UDP 67/68 entre fw01 y dc01).

## 5. Cliente unido al dominio
- VM `cli-win01` en `lan-usuarios`, debe recibir IP del DHCP de dc01 (con DNS = `192.168.20.10`).
- Une el equipo al dominio `pyme.lan` e inicia sesión con un usuario del dominio.

## 6. GPO sugeridas
Crea y vincula a las OUs adecuadas:
| GPO | Dónde | Qué hace |
|---|---|---|
| Política de contraseñas | Dominio | Longitud mínima 12, bloqueo tras 5 intentos |
| Fondo corporativo | Usuarios | Fondo de escritorio por directiva |
| Unidades de red | Por departamento | Mapea la carpeta de su departamento |
| Restringir Panel de control | Ventas, Administración | Limita configuración local |
| Bloqueo de pantalla | Equipos | 10 minutos de inactividad |
| Impresoras/ajustes | Opcional | Lo que se te ocurra para practicar |

Comprueba en el cliente con `gpupdate /force` y `gpresult /r`.

## 7. Carpetas compartidas y permisos
Modelo recomendado (AGDLP): usuarios → grupos globales (`GG_Ventas`) → grupos locales de dominio (`GL_Ventas_Modificar`) → permiso sobre la carpeta.
- Comparte `D:\Datos\Ventas`, `D:\Datos\Administracion`, etc.
- Permiso de recurso compartido: Control total a Usuarios autenticados. Los permisos reales se hacen con **NTFS**.
- Demuestra que un usuario de Ventas no accede a Administración.

## Comprobaciones
- [ ] `nslookup dc01.pyme.lan` resuelve desde los clientes
- [ ] El cliente recibe IP del DHCP de dc01
- [ ] Usuario de dominio inicia sesión en `cli-win01`
- [ ] GPO aplicadas (`gpresult /r`)
- [ ] Un usuario no puede acceder a la carpeta de otro departamento

## Qué documentar
- Captura de usuarios y equipos de AD, GPO y permisos NTFS.
- Salida de `gpresult /r`, `ipconfig /all`, `nslookup`.
- Tabla de grupos y permisos.

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| El cliente no encuentra el dominio | Su DNS no apunta a dc01 |
| No puede unirse al dominio | Reglas de firewall de `PUERTOS_AD` incompletas o hora desincronizada |
| GPO no se aplica | GPO no vinculada a la OU correcta o equipo/usuario en otra OU |
| Lentitud al iniciar sesión | DNS mal configurado (casi siempre es DNS) |

## Resultado (rellena al terminar)
