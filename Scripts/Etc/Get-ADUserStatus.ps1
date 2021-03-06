param([Parameter(Mandatory=$true)][string]$samaccountname)
$lockedout = "False"
$dcs = get-addomaincontroller -Filter { OperatingSystem -notlike "Windows Server 2003" -and OperatingSystem -notlike "Windows Server® 2008 Standard" }
foreach ( $dc in $dcs )
	{
	$dcname = $dc.name
	if ( ( get-aduser $samaccountname -properties lockedout -server $dcname -ErrorAction SilentlyContinue ).lockedout -eq "True" )
		{
		$lockedout = "True"
		$dclocked = $dclocked + $dcname + " " 
		} 
	}	
$output = get-aduser $samaccountname -properties Office, ScriptPath, PasswordExpired, PasswordLastSet, Created, Lockedout
$output.LockedOut = $lockedout
$output.dc = $dclocked
$output | format-list Lockedout, PasswordExpired, PasswordLastSet, Created, Office, ScriptPath
