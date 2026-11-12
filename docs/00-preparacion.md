# Fase 0 · Preparación del entorno

## Objetivo

Tener el portátil, el hipervisor, las ISO y el repositorio de Git listos antes de crear ninguna máquina.

## 1\. BIOS y sistema anfitrión

* Activa la virtualización en la BIOS/UEFI. En tu Ryzen se llama **SVM Mode**.
* Con VirtualBox en Windows, si tienes Hyper-V / WSL2 / Aislamiento de núcleo activos, VirtualBox funciona pero más lento. Lo ideal para el laboratorio es desactivar Hyper-V o usar VMware Workstation, que convive mejor.
* Deja libres al menos 150 GB en un SSD.

## 2\. Hipervisor (elige uno)

* **VirtualBox** (gratuito, sencillo). La interfaz gráfica solo muestra 4 adaptadores de red por VM; el quinto se añade por línea de comandos (ver fase 2).
* **VMware Workstation Pro** (gratuito para uso personal). Permite más adaptadores y "LAN segments" cómodos.

## 3\. Descargas

|Qué|Dónde|
|-|-|
|OPNsense (imagen `dvd`, amd64)|opnsense.org/download|
|Windows Server 2022 (ISO de evaluación, 180 días)|Centro de evaluación de Microsoft|
|Windows 10/11 (cliente, opcional)|Microsoft (ISO de evaluación o tu licencia)|
|Ubuntu Server LTS|ubuntu.com/download/server|
|Cliente Linux ligero (Lubuntu o Linux Mint XFCE)|sus webs oficiales|
|Git|git-scm.com|
|Visual Studio Code (opcional)|code.visualstudio.com|

Comprueba siempre el hash SHA256 de cada ISO.

## 4\. Convención de nombres

|VM|Nombre|RAM|CPU|Disco|
|-|-|-|-|-|
|Firewall|`fw01`|1-2 GB|1|16 GB|
|Cliente Linux|`cli-linux01`|2 GB|2|20 GB|
|Cliente Windows|`cli-win01`|2 GB|2|40 GB|
|Controlador de dominio|`dc01`|3 GB|2|50 GB|
|Servidor web|`srv-web`|1 GB|1|20 GB|
|Monitorización + Ansible|`srv-mon`|2 GB|2|30 GB|

Usa discos de **asignación dinámica**.

## 5\. RAM por fase (qué encender)

|Fase|Máquinas encendidas|RAM aprox.|
|-|-|-|
|1-2|fw01 + cli-linux01|3-4 GB|
|3|fw01 + dc01 + cli-win01|6-7 GB|
|4|fw01 + srv-web + cli-linux01|4-5 GB|
|5|fw01 + dc01 + srv-web + srv-mon|7-8 GB|
|6|fw01 + srv-mon + srv-web|4-5 GB|
|7|fw01 + dc01 + (cliente VPN en el anfitrión)|5 GB|

Regla: **no necesitas todo encendido a la vez**. Cierra el navegador y lo que no uses en el anfitrión.

## 6\. Snapshots

Antes de cada cambio grande, crea un snapshot con nombre descriptivo (`antes-de-ad`, `fase2-ok`). Si rompes algo, vuelves atrás en segundos.

## 7\. Repositorio Git

```bash
cd homelab-pyme
git init
git add .
git commit -m "Estructura inicial del proyecto"
git branch -M main
git remote add origin https://github.com/TU\_USUARIO/homelab-pyme.git
git push -u origin main
```

Crea antes el repositorio vacío en GitHub. Configura tu identidad si no lo has hecho:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@correo.com"
```

## Comprobaciones

* \[x] Virtualización activa y hipervisor instalado
* \[x] ISO descargadas y verificadas
* \[x] Repositorio subido a GitHub
* \[x] Espacio suficiente para VMs y snapshots

## Resultado

*-VirtualBox ya instalado y actualizado. Virtualización (SVM) activada en la BIOS desde antes.*

*-ISO descargadas: OPNsense (amd64, dvd), Lubuntu, Windows Server 2022, Windows 11, Ubuntu Server LTS.*

*-Instalación de Git.*

*-Repositorio creado en GitHub y subido desde Git Bash. Se ha creado un nombre y email.*

*-Incidencia: la carpeta del proyecto quedó anidada y se corrigió reiniciando Git en la carpeta interior.*

