Write-Host "Loading.." -ForegroundColor Yellow
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
function Ask-Reboot
	{
	$OUTPUT= [System.Windows.Forms.MessageBox]::Show("Ready to restart?" , "Complete" , 4)
	if ( $OUTPUT -eq "YES" )
		{
		Write-Host "Restarting Computer" -ForegroundColor Yellow
		Restart-Computer -Force
		}
	else
		{
		Write-Host "Reboot when ready." -ForegroundColor Yellow
		Read-Host
		}
	}
	
Function Set-ScriptContinue([string]$PSCmd) 
	{  
    $RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" 
    set-itemproperty $RunOnceKey "ConfigureServer" ($pscmd)
  	# Autologin so the runonce is run
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "ccmhmr\Administrator"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "2x68LFU"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value "1"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value "1"
	# Add a folder (proof)
	} 

## Remove Old ##

$oldinstalls = Get-WmiObject win32_product | ? { $_.name -match "Citrix" }

if ( $oldinstalls -ne $null )
{
foreach ( $oldinstall in $oldinstalls )
	{
	$name = $oldinstall.name
	Write-Host "Uninstalling $name" -ForegroundColor Yellow
	$oldinstall.uninstall()
	}
}
## Remove Icons ##

$icons = "Anasazi", "ECI Database", "Citrix", "BH - VO Auths Database", "RDM Database"
Write-Host "Adjusting Icons" -ForegroundColor Yellow
get-childitem c:\Users\Public\Desktop | ? { $_.name -match $icons[0] -or $_.name -match $icons[1] -or $_.name -match $icons[2] -or $_.name -match $icons[3] -or $_.name -match $icons[4] } | remove-item -Force
Copy-Item "CAG Address.txt" -Destination c:\Users\Public\Desktop -Force

## Install Online Plugin ##

Write-Host "Installing Online Plugin" -ForegroundColor Green
.\CitrixOnlinePluginFull.exe /SERVER_LOCATION=https://"misctrx1.ccmhmr.local" /ENABLE_DYNAMIC_CLIENT_NAME=Yes /Silent | Out-Null
Write-Host "Moving Online Plugin Icon" -ForegroundColor Green
Move-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Online plug-in.lnk" -Destination c:\Users\Public\Desktop -Force

## Disable Network Adapters

$enabled = Get-WmiObject win32_NetworkAdapter | ? { $_.netenabled -eq $True }
Write-Host "Disabling Network" -ForegroundColor Yellow
foreach ( $nic in $enabled )
{
$nic.disable()
}

## Install CAG ##

Write-Host "Attempting to install Cag" -ForegroundColor Green
./CitrixAGP.exe -Q -i | Out-Null
if ( test-path 'C:\Program Files (x86)\Citrix\Access Gateway\cag_plugin.exe' )
	{
	Write-Host "CAG has been installed!" -ForegroundColor Green
	Write-Host "Copying Cag Shortcut" -ForegroundColor Green
	Copy-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Citrix\Citrix Access Clients\Citrix Access Gateway.lnk' -Destination C:\Users\Public\Desktop
	## Enable Network Adapters

	Write-Host "Enabling Network" -ForegroundColor Yellow
	foreach ( $nic in $enabled )
		{
		$nic.enable()
		}
	## Restart Computer ##
	Write-Host "Reboot Dialog Box" -ForegroundColor Yellow
	Ask-Reboot
	}
else
	{
	Write-Host "Cag has not been installed.. :(" -ForegroundColor Red
	## Enable Network Adapters ##
	Write-Host "Enabling Network" -ForegroundColor Yellow
	foreach ( $nic in $enabled )
		{
		$nic.enable()
		}
	
	## Copy Scripts ##
	Write-Host "Copying Scripts" -ForegroundColor Yellow
	$Folder = "C:\Users\administrator\Desktop\runonce\"
	mkdir $folder
	copy-item "Install-CAG.exe" -Destination $Folder -Force
	Copy-Item "CitrixAGP.exe" -Destination $Folder -Force
	## Set-Scriptcontinue ##
	Write-Host "Setting Script to Continue after Reboot" -ForegroundColor Yellow
	$command = Join-Path -Path $Folder -ChildPath Install-CAG.exe
	Set-ScriptContinue -pscmd $command
	## Reboot ##
	Write-Host "Reboot Dialog Box" -ForegroundColor Yellow
	Ask-Reboot
	}





