<#
    .SYNOPSIS
    Low Level Discovery of Active Directory users for Zabbix.

    .DESCRIPTION
    Works with PowerShell 3.0 and above because of ConvertTo-JSON

    .PARAMETER LdapFilter
    LdapFiler to return only appropriate users.

    .EXAMPLE

    .NOTES
    Author: Khatsayuk Alexander
    Github: https://github.com/asand3r/
#>

Param (
    [Parameter(Position=0, Mandatory=$True)][string]$ldapFilter = "(&(objectClass=Person))"
)

$users = Get-ADUser -LDAPFilter $ldapFilter -Properties Description

$lldObject = @()

$users | ForEach-Object {
    $user = New-Object psobject
    Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.LOGIN}" -Value $_.SamAccountName
    Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.NAME}" -Value $_.Name
    $lldObject += $user
}

@{"data" = $lldObject} | ConvertTo-Json -Compress