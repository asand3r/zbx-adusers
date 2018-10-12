# zbx-aduserspasswords
Low Level Discovery Active Directory Users and send password expired date to Zabbix Server

# DISCLAIMER
Kind of 'just for fun' solution. But, someone can find it helpful.

![alt](https://pp.userapi.com/c850532/v850532773/204a2/tXYicR_w_Ho.jpg)
![alt](https://pp.userapi.com/c850532/v850532773/204ee/bXIcI26vGwk.jpg)

# Requirements
 - PowerShell v3.0+
 
# Installation
OK, so it has two PowerShell scripts:
 - LLD-ADUsers.ps1  
   Implemet Low-Level Discovery functional. Return JSON object, contains user login (sAMAccountName) and name (Name) attributes:
  ```powershell
  {"data":[{"{#USER.LOGIN}":"asand3r","{#USER.NAME}":"Khatsayuk Aleksandr Andreevich"}]}     
  ```
 - Get-UsersPasswordExpired.ps1  
   Return list suitable to zabbix_sender utility. It contains Zabbix host name, which you will link the template, zabbix host key name and days before password will expire: 
   ```powershell
   ZABBIX_HOST_NAME user.expired.days[asand3r] 42
   ```
