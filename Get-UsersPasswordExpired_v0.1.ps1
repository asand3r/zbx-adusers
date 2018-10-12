<#
    .SYNOPSIS
    List of AD users with password expired days in Zabbix Sender format

    .DESCRIPTION
    Return users list in format suitable for Zabbix Sender utility.

    .PARAMETER LdapFilter
    LdapFiler to return only appropriate users.

    .EXAMPLE
    Get-UsersPasswordExpired -ldapFilter "(&(objectClass=Person)(company=Microsoft))"
    
    .NOTES
    Author: Khatsayuk Alexander
    Github: https://github.com/asand3r/
#>

Param (
    [Parameter(Position=0, Mandatory=$True)][string]$ldapFilter = "(&(objectClass=Person))"
)

$users = Get-ADUser -LDAPFilter $ldapFilter -Properties PasswordLastSet
$hostName = "SHV-VDC01"

$users | ForEach-Object {
    [int]$days = ($_.PasswordLastSet - $(Get-Date).AddDays(-90)).Days
    if ($days -lt 0) {$days = 0}
    $ZabbixItemName = "user.expired.days[$($_.SamAccountName)]"
    $hostName, $ZabbixItemName, $days -join " "
}