# Fase 6 · Automatización con Ansible y CI

## Objetivo
Que los servidores Linux se configuren solos y de forma repetible, y que GitHub valide tu código en cada subida.

## 1. Instalar Ansible en `srv-mon`
```bash
sudo apt update && sudo apt install -y ansible git
ansible --version
ansible-galaxy collection install community.general
```
Clona tu repositorio en `srv-mon`:
```bash
git clone https://github.com/TU_USUARIO/homelab-pyme.git
cd homelab-pyme/ansible
```

## 2. Acceso por clave SSH
```bash
ssh-keygen -t ed25519
ssh-copy-id admin@192.168.40.10
ssh-copy-id admin@192.168.20.20
```
Comprueba que `admin` tiene `sudo` (en Ubuntu, el usuario creado en la instalación ya lo tiene). Si quieres que `become` no pida contraseña, usa `--ask-become-pass` o configura sudo sin contraseña solo en el laboratorio.

## 3. Inventario y primera prueba
Revisa `ansible/inventory.ini` y `ansible/group_vars/all.yml`. Después:
```bash
ansible all -m ping
```

## 4. Playbooks incluidos
| Playbook | Qué hace |
|---|---|
| `base.yml` | Actualiza índice, instala paquetes, zona horaria, UFW (SSH), endurece `sshd` |
| `web.yml` | Instala nginx, genera certificado autofirmado, despliega vhost y página, abre 80/443 |
| `zabbix_agent.yml` | Instala y configura el agente de Zabbix apuntando a `srv-mon` |
| `site.yml` | Ejecuta los anteriores en orden |

Ejecución recomendada:
```bash
ansible-playbook playbooks/site.yml --syntax-check
ansible-playbook playbooks/site.yml --check --diff     # simulación
ansible-playbook playbooks/site.yml --ask-become-pass  # real
```
**Idempotencia:** ejecuta el playbook dos veces; la segunda debe salir con `changed=0`. Hazlo captura para el README.

> Antes de lanzar `base.yml` en producción, asegúrate de que `ufw` permite SSH desde `srv-mon` (el playbook abre el 22 a todos en el laboratorio; en la fase 4 lo restringiste a mano, ajústalo si quieres).

## 5. Retos para crecer
1. Convertir los playbooks en **roles** (`ansible-galaxy init roles/web`).
2. Guardar secretos con **Ansible Vault**.
3. Añadir un playbook que despliegue [`scripts/backup.sh`](../scripts/backup.sh) y su cron.
4. Gestionar Windows con WinRM (`ansible.windows`) para tareas simples.

## 6. Integración continua (GitHub Actions)
El flujo `.github/workflows/lint.yml` ya está incluido y ejecuta en cada `push` o `pull request`:
- `ansible-lint` sobre `ansible/`
- `ansible-playbook --syntax-check`
- `shellcheck` sobre `scripts/*.sh`

Tras subirlo, ve a la pestaña **Actions** del repositorio, corrige lo que marque el linter y añade al README la insignia (badge) del estado:
```markdown
![Lint](https://github.com/TU_USUARIO/homelab-pyme/actions/workflows/lint.yml/badge.svg)
```

## 7. Script en Python (opcional)
[`scripts/informe_red.py`](../scripts/informe_red.py) comprueba puertos clave de tus servidores y genera una tabla Markdown. Puedes ampliarlo para que escriba el informe en un fichero, lo programe con cron o envíe el resultado por Telegram.

## Comprobaciones
- [ ] `ansible all -m ping` responde con `pong`
- [ ] `site.yml` se aplica sin errores
- [ ] Segunda ejecución con `changed=0`
- [ ] La Action de GitHub aparece en verde

## Qué documentar
- Salida de las dos ejecuciones del playbook.
- Captura de la Action pasando.
- Explicación breve de cada playbook en el README.

## Problemas típicos
| Síntoma | Causa probable |
|---|---|
| `UNREACHABLE` | SSH, firewall o clave sin copiar |
| `Missing sudo password` | Falta `--ask-become-pass` |
| `ansible-lint` se queja de nombres/FQCN | Usa nombres de módulo completos (`ansible.builtin.…`) y `name:` en cada tarea |

## Resultado (rellena al terminar)
