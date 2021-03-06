$dns = "192.168.1.5","192.168.1.6"
$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername . | where{$_.IPEnabled -eq $true} 
Foreach($NIC in $NICs) { 
    $NIC.SetDNSServerSearchOrder($dns) 
    $NIC.SetDynamicDNSRegistration("TRUE") 
} 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null 
$name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Desired Computer Name ")
$computer = Get-WmiObject Win32_ComputerSystem
$computer.joindomainorworkgroup("ACP.local" , "Angels+8165", "itadmin", $null, 3)
$computer.Rename($name, "Angels+8165", "ACP\itadmin")
restart-computer -force