cls
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
Restart-Computer -Force
} 
Set-ScriptContinue "C:\scripts\runoncetest.exe"