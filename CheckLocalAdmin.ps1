param (
    [Parameter(Mandatory = $false, HelpMessage = "Specify the Active Directory domain name (e.g., yourdomain.local)")]
    [string]$domain,

    [Parameter(Mandatory = $false, HelpMessage = "Specify the username to check for local admin rights")]
    [string]$username,

    [switch]$ShowHelp
)

# Function to display the help message
function Show-Help {
    Write-Host @"
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
"@
}

# Check if help should be displayed
if ($ShowHelp) {
    Show-Help
    exit
}

# Prompt for input if parameters are missing
if (-not $domain.Trim() -or -not $username.Trim()) {
    Write-Host "ERROR: Please provide both domain and username parameters."
    Show-Help
    exit 1
}

# Get list of computers from Active Directory
$computers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name

# Loop through each computer
foreach ($computer in $computers) {
    Write-Host "Checking $computer..."

    # Try to establish a remote PowerShell session
    try {
        $session = New-PSSession -ComputerName $computer -ErrorAction Stop
        
        # Check if the user is a member of the local Administrators group
        $isAdmin = Invoke-Command -Session $session -ScriptBlock {
            param($username)
            $admins = [System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.SecurityIdentifier]::new([System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value))
            $admins.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator) -or (Get-LocalGroupMember Administrators | Where-Object { $_.Name -eq $using:username })
        } -ArgumentList $Username -ErrorAction Stop

        if ($isAdmin) {
            Write-Host "$username is a local administrator on $computer."
        } else {
            Write-Host "$username is not a local administrator on $computer."
        }
    } catch {
	$errorMessage = "Failed to connect to" + $computer + ":" + $_.Exception.Message
        Write-Host $errorMessage
    } finally {
        if ($session) {
            Remove-PSSession $session
        }
    }
}
