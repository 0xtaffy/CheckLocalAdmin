## CheckLocalAdmin

This is simple powershell script made with the help of chatgpt to automate the process of looking for computers in a active directory domain where 
you are a local admin. As normally would be required to run the below command for every single computer within the domain to determine if you were 
local admin on that computer.

```powershell
ls \\computer\\C$
```
This gets super tedious especially when in a large enterprise active directory network.

**Note this script will require powershell remoting to be enabled to work**


### Display help

You can display the help menu with the following

```powershell
.\CheckLocalAdmin.ps1 -ShowHelp
DESCRIPTION:
This script checks if a specified username is a local administrator on computers within the specified Active Directory domain.

USAGE:
./CheckLocalAdmin.ps1 [-domain <domain_name>] [-username <username>] [-ShowHelp]

PARAMETERS:
-domain <domain_name>      : Specify the Active Directory domain name (e.g., yourdomain.local)
-username <username>       : Specify the username to check for local admin rights
-ShowHelp                  : Display this help message and exit

REQUIREMENTS FOR REMOTE SESSIONS:
1. The script requires PowerShell remoting to be enabled on target computers.
2. The user running the script must have appropriate permissions to establish remote sessions (e.g., local administrator privileges on target computers).

EXAMPLES:
1. Check if 'JohnDoe' is a local administrator in 'example.com':
   .\CheckLocalAdmin.ps1 -domain "example.com" -username "JohnDoe"
```
