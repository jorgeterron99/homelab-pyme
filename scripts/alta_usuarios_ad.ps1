<#
.SYNOPSIS
    Alta masiva de usuarios en Active Directory desde un CSV.
.DESCRIPTION
    Columnas del CSV: Nombre,Apellidos,Usuario,Departamento
    Cada usuario se crea en OU=<Departamento>,OU=Usuarios y se añade al grupo GG_<Departamento>.
    La contraseña inicial es de laboratorio y se obliga a cambiarla en el primer inicio de sesión.
.EXAMPLE
    .\alta_usuarios_ad.ps1 -CsvPath .\usuarios.csv
#>
param(
    [string]$CsvPath = ".\usuarios.csv",
    [string]$Dominio = "pyme.lan",
    [string]$BaseDN = "DC=pyme,DC=lan",
    [string]$PasswordInicial = "Cambiame#2026"
)

Import-Module ActiveDirectory
$passwordSegura = ConvertTo-SecureString $PasswordInicial -AsPlainText -Force

Import-Csv -Path $CsvPath -Encoding UTF8 | ForEach-Object {
    $sam = $_.Usuario
    $ou  = "OU=$($_.Departamento),OU=Usuarios,$BaseDN"

    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue)) {
        Write-Warning "La OU no existe para $sam ($ou). Ejecuta antes crear_estructura_ad.ps1."
        return
    }

    if (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
        Write-Host "Ya existe: $sam"
        return
    }

    New-ADUser -Name "$($_.Nombre) $($_.Apellidos)" `
        -GivenName $_.Nombre `
        -Surname $_.Apellidos `
        -SamAccountName $sam `
        -UserPrincipalName "$sam@$Dominio" `
        -Path $ou `
        -AccountPassword $passwordSegura `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Add-ADGroupMember -Identity "GG_$($_.Departamento)" -Members $sam
    Write-Host "Creado: $sam en $($_.Departamento)"
}
