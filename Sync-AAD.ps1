<#
.Synopsis
Sync-AAD will start a session with an on prem AAD server and start a full or delta synchronization

.Description
Sync-AAD will start a session with an on prem AAD server and start a full or delta synchronization.
It does not require you to RDP or otherwise access the AAD server so you can run it from any machine
on the network.

.Parameter AADServer
The name of the AAD server

.Parameter Type
Designates full or delta synchronization.  Defaults to delta.

.Example
.\Sync-AAD.ps1 -AADServer AADS01 -Type Delta

PSComputerName RunspaceId                           Result
-------------- ----------                           ------
AADS01      d27b531e-4a03-4d1d-8ef8-723a30d4d6d1 Success

.Example
.\Sync-AAD.ps1 -AADServer AADS01 -Type Full

PSComputerName RunspaceId                           Result
-------------- ----------                           ------
AADS01      c8840c4b-7733-4db7-958e-c24189b8a974 Success
#>

# Parameter defines AAD Server
Param(
    [Parameter(Mandatory = $True)]
    [string]$AADServer,
    [Parameter(Mandatory = $False)]
    [string]$Type = "Delta"
)

# Connect session, do complete synchronization, and remove the session
$session = New-PSSession -ComputerName $AADServer
Invoke-Command -Session $session -ScriptBlock {Import-Module -Name 'ADSync'}
Invoke-Command -Session $session -ScriptBlock {Start-ADSyncSyncCycle -PolicyType $Type}
Remove-PSSession $session
