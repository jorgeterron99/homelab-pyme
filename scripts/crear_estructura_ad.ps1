<#
.SYNOPSIS
    Crea la estructura base de OUs y grupos en pyme.lan.
.NOTES
    Ejecutar en dc01 como administrador del dominio.
#>
Import-Module ActiveDirectory

$BaseDN = "DC=pyme,DC=lan"
$Departamentos = @("Direccion", "Administracion", "Ventas", "IT")

function Nueva-OU {
    param([string]$Nombre, [string]$Ruta)
    $dn = "OU=$Nombre,$Ruta"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Nombre -Path $Ruta -ProtectedFromAccidentalDeletion $true
        Write-Host "OU creada: $dn"
    } else {
        Write-Host "OU ya existe: $dn"
    }
}

Nueva-OU -Nombre "Usuarios" -Ruta $BaseDN
Nueva-OU -Nombre "Equipos"  -Ruta $BaseDN
Nueva-OU -Nombre "Grupos"   -Ruta $BaseDN

foreach ($dep in $Departamentos) {
    Nueva-OU -Nombre $dep -Ruta "OU=Usuarios,$BaseDN"

    $grupo = "GG_$dep"
    if (-not (Get-ADGroup -Filter "Name -eq '$grupo'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $grupo -GroupScope Global -GroupCategory Security `
            -Path "OU=Grupos,$BaseDN" -Description "Usuarios de $dep"
        Write-Host "Grupo creado: $grupo"
    }
}
