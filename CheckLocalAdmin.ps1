# Define the target command to execute on each computer
$commandToExecute = "ls '\\$computer\c$'"

# Get list of computers from Active Directory
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# Loop through each computer
foreach ($computer in $computers) {
    Write-Host "Executing command on $computer..."
    
    # Use Invoke-Command to run the command on the remote computer
    try {
        Invoke-Command -ComputerName $computer -ScriptBlock {
            param($command)
            Invoke-Expression $command
        } -ArgumentList $commandToExecute -ErrorAction Stop
    } catch {
        Write-Host "Failed to execute command on $computer: $_"
    }
}
