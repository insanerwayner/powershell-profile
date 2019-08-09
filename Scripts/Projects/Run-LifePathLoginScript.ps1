Write-Progress -Activity "Running LifePath Logon Script" -Status "Starting" -PercentComplete 0
Write-Progress -Activity "Running LifePath Logon Script" -Status "Refreshing DNS" -PercentComplete 5
ipconfig /flushdns
ipconfig /registerdns
Write-Progress -Activity "Running LifePath Logon Script" -Status "Testing Connectivity" -PercentComplete 10
if ( Test-Connection DC01.ccmhmr.local -Count 1 -BufferSize 1 -Quiet )
	{
	$server = "DC01.ccmhmr.local"
	}
else
	{
	$server = "DC02.ccmhmr.local"
	}
Write-Progress -Activity "Running LifePath Logon Script" -Status "Getting Login Script" -PercentComplete 50
$domain = [Environment]::UserDomainName
$username = [Environment]::UserName
$User = [ADSI]("WinNT://" + $server + "/" + $username)
$script = "\\" +$domain + "\netlogon\" + $User.LoginScript
Write-Progress -Activity "Running LifePath Logon Script" -Status "Running Login Script" -PercentComplete 95
Start-Process $script
Write-Progress -Activity "Running LifePath Logon Script" -Status "Complete" -PercentComplete 100
