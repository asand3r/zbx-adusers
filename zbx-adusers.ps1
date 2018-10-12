<#
    .SYNOPSIS
    Low Level Discovery of Active Directory users for Zabbix.

    .DESCRIPTION
    Works with PowerShell 3.0 and above because of ConvertTo-JSON

    .PARAMETER action
    What script must to do - LLD of generate data for zabbix_sender.

    .PARAMETER LdapFilter
    LdapFiler to return only appropriate users.

    .PARAMETER HostName
    Name of host in Zabbix where script must send data by trapper.
    Use it only with "sender".

    .EXAMPLE
    zbx-adusers lld "(&(company=Zabbix)(department=MSI package build team))"

    .EXAMPLE
    zbx-adusers sender "(&(company=Zabbix)(department=MSI package build team))" "SVRDC1"

    .NOTES
    Author: Khatsayuk Alexander
    Github: https://github.com/asand3r/
#>

Param (
    [ValidateSet("lld","sender")][Parameter(Position=0, Mandatory=$True)][string]$action,
    [Parameter(Position=1, Mandatory=$False)][string]$LdapFilter = "(&(objectClass=User)(objectClass=Person))",
    [Parameter(Position=2, Mandatory=$False)][string]$HostName
)

# Script version
$version = "0.1.1"
# Array to store users objects
$lldObject = @()
# Users properties to retrieve from LDAP
$user_props = "description", "emailaddress", "department", "title", "PasswordNeverExpires"

$users = Get-ADUser -LDAPFilter $ldapFilter -Properties $user_props
switch ($action) {
    "lld" {
        $users | ForEach-Object {
            $user = New-Object psobject
            Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.LOGIN}" -Value $_.SamAccountName
            Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.NAME}" -Value $_.Name
            Add-Member -InputObject $user -type NoteProperty -Name "{#USER.EMAIL}" -Value $_.emailaddress
            Add-Member -InputObject $user -type NoteProperty -Name "{#USER.DEPARTMENT}" -Value $_.department
            Add-Member -InputObject $user -type NoteProperty -Name "{#USER.TITLE}" -Value $_.title
            Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.ENABLED}" -Value $([int]$_.Enabled)
            Add-Member -InputObject $user -Type NoteProperty -Name "{#USER.NEVEREXPIRES}" -Value $([int]$_.PasswordNeverExpires)
            $lldObject += $user
        }
        Write-Host $(ConvertTo-Json -InputObject @{"data" = $lldObject} -Compress) -NoNewline
    }

    "sender" {
        Get-ADUser -LDAPFilter $LdapFilter -Properties PasswordLastSet | ForEach-Object {
            [int]$days = ($_.PasswordLastSet - $(Get-Date).AddDays(-90)).Days
            if ($days -lt 0) {
                $days = 0
            }
            if ($HostName -eq "") {
                $HostName = $env:COMPUTERNAME
            }
            $ItemName = "user.expired.days[$($_.SamAccountName)]"
            Write-Host $([string]::Format('"{0}" "{1}" {2}', $HostName, $ItemName, $days))
        }
    }
}