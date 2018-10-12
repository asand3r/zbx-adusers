# zbx-adusers
Low Level Discovery Active Directory Users and send password expired date to Zabbix Server

![alt](https://pp.userapi.com/c850532/v850532773/204a2/tXYicR_w_Ho.jpg)
![alt](https://pp.userapi.com/c850532/v850532773/204ee/bXIcI26vGwk.jpg)

# Requirements
 - PowerShell v3.0+
 - zabbix_sender.exe
 
# Installation
There is one PowerShell script:
 - zbx-adusers.ps1  

Just create "scripts" folder near your Zabbix agent binaris and copy settings from userparameter.conf file to your zabbix_agentd.conf. After this restart the agent.  
![alt](https://pp.userapi.com/c844521/v844521604/112536/cREnK76m7w0.jpg)  
You can check the script by zabbix_get utility:  
```bash
[root@zabbix ~]# zabbix_get -s SERVER01 -k 'ad.users["lld", "&(objectClass=User)(objectClass=Person)"]'
{"data":[{"{#USER.LOGIN}":"asand3r","{#USER.NAME}":"Khatsayuk Aleksandr Andreevich","{#USER.EMAIL}":"asand3r@github.com","{#USER.DEPARTMENT}":"IT","{#USER.TITLE}":"System Administrator","{#USER.ENABLED}":1,"{#USER.NEVEREXPIRES}":0}]}
```
To check days retrieving, run it wit 'sender' argument:
```bash
[root@zabbix ~]# zabbix_get -s SERVER01 -k 'ad.users["sender", "&(objectClass=User)(objectClass=Person)"]'
"SERVER01" "user.expired.days[asand3r]" 42  
"SERVER01" "user.expired.days[tolstoy_ln]" 24
```

# Script 
It supports three arguments:  
 - action  
 - LdapFilter  
 - HostName  
 
The first one accepts "lld" for do LLD and "sender" to prepare data in format suitable for zabbix_sender.exe utility. It's mandatory;  
The second one - filter in ldapFilter format. It's using to find only needed user object in LDAP. Read this article to understand how it works: https://docs.microsoft.com/en-us/windows/desktop/adsi/search-filter-syntax  
The third - name of hosts in Zabbix where you linked the template. By default it's $env:COMPUTERNAME.  
