## CheckLocalAdmin

This is simple powershell script made with the help of chatgpt to automate the process of looking for computers in a active directory domain where 
you are a local admin. As normally would be required to run the below command for every single computer within the domain to determine if you were 
local admin on that computer.

```powershell
ls \\computer\\C$
```
This gets super tedious especially when in a large enterprise active directory network. So this script automates and executes the command for each computer in the network.
