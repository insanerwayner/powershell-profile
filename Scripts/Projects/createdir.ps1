# Add a folder (proof) - perform actions here
mkdir "C:\createdir1-36-test-2nd-run"
# Remove the runonce
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value "0"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name ForceAutoLogon -Value "0"
Restart-Computer -Force  # Restart and verify you are not logging in