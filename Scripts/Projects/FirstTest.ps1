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
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "ccmhmr\wreeves"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "Iforgot2"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value "1"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value "1"
	# Add a folder (proof)
	} 



## Copy Scripts ##
Write-Host "Copying Scripts" -ForegroundColor Yellow
$Folder = "C:\Users\wreeves\Desktop\Runonce"
mkdir $folder
copy-item runoncetest.exe -Destination $Folder -force
## Set-Scriptcontinue ##
Write-Host "Setting Script to Continue after Reboot" -ForegroundColor Yellow
$command = Join-Path -Path $Folder -ChildPath "runoncetest.exe"
Set-ScriptContinue -pscmd $command
## Reboot ##
Write-Host "Reboot Dialog Box" -ForegroundColor Yellow
Ask-Reboot