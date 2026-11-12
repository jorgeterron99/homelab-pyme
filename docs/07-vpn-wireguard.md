# Fase 7 · VPN con WireGuard

## Objetivo
Acceso remoto seguro a la red interna y, como ampliación, un túnel entre dos sedes.

## Parte A · Acceso remoto (road warrior)

### Esquema
```
Portátil (cliente WireGuard) ══ UDP 51820 ══ WAN fw01
Túnel: 10.10.10.0/24  (fw01 = 10.10.10.1, cliente = 10.10.10.2)
```

### 1. En OPNsense
Las versiones recientes incluyen WireGuard integrado (VPN → WireGuard); en versiones anteriores hay que instalar el plugin `os-wireguard` (System → Firmware → Plugins). Los menús cambian entre versiones, pero el esquema es siempre el mismo:
1. Crea la **instancia local** (par de claves, puerto 51820, dirección del túnel `10.10.10.1/24`).
2. Crea un **peer** (el cliente) con su clave pública y `AllowedIPs = 10.10.10.2/32`.
3. Asigna la interfaz WireGuard (Interfaces → Assignments) y actívala.
4. **Reglas:**
   - WAN: permitir UDP 51820 hacia "This Firewall".
   - Interfaz WireGuard: permitir hacia `192.168.20.0/24` y `192.168.10.0/24` (o solo lo necesario).
5. Comprueba que el NAT outbound o las rutas permiten que los servidores respondan a `10.10.10.0/24`.

### 2. En el cliente
Instala WireGuard en el portátil anfitrión y crea el túnel:
```ini
[Interface]
PrivateKey = <clave privada del cliente>
Address = 10.10.10.2/32
DNS = 192.168.20.10

[Peer]
PublicKey = <clave pública de fw01>
Endpoint = IP_O_NOMBRE_DE_FW01:51820
AllowedIPs = 192.168.10.0/24, 192.168.20.0/24, 10.10.10.0/24
PersistentKeepalive = 25
```
> **Nunca subas claves privadas al repositorio.** Documenta la estructura con valores de ejemplo (`<clave>`).

### 3. Alcanzar fw01 desde el anfitrión
Con la WAN en NAT, el anfitrión no llega a fw01. Opciones:
- Reenvío de puertos de VirtualBox (Adaptador 1 → NAT → Reenvío de puertos: UDP 51820 del anfitrión a la IP WAN de fw01).
- O cambia la WAN a **adaptador puente**, pero entonces fw01 queda expuesto a tu red local: refuerza las reglas.

### 4. Pruebas
- `ping 10.10.10.1` desde el cliente.
- `ping 192.168.20.10` (dc01) a través del túnel.
- Abrir `https://srv-web.pyme.lan` desde el túnel.
- En OPNsense: VPN → WireGuard → estado (handshake reciente).

## Parte B · Site-to-site (ampliación)
Simula una sede secundaria con una VM (`fw02`, otro OPNsense o un Linux con WireGuard) y red `192.168.50.0/24`.
- Túnel: `10.10.20.0/24` (fw01 = .1, fw02 = .2).
- `AllowedIPs` de cada lado = la red remota + la IP del túnel.
- Rutas y reglas en ambos extremos.
- Prueba: un equipo de `192.168.50.0/24` llega a `192.168.20.10` y viceversa.

## Comprobaciones
- [ ] Handshake visible en OPNsense
- [ ] Acceso a dc01 y srv-web desde la VPN
- [ ] Reglas mínimas (solo lo que debe verse)
- [ ] (Ampliación) Túnel site-to-site operativo

## Qué documentar
- Esquema del túnel, tabla de redes y `AllowedIPs`.
- Capturas del estado, `ping` y reglas (sin claves privadas).

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| Sin handshake | Puerto UDP no llega a fw01 (NAT del hipervisor, regla en WAN) |
| Handshake pero sin tráfico | Falta regla en la interfaz WireGuard o `AllowedIPs` incorrectos |
| Llegas a fw01 pero no a los servidores | Rutas de retorno o reglas entre zonas |

## Resultado (rellena al terminar)
