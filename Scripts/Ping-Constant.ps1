param( 
	[Parameter(Mandatory=$True,Position=1)]
   	[string]$computerName
)
Write-Host (Get-Date -Format "MM-dd-yy hh:mm:ss" ) -ForegroundColor Yellow
$starttime = Get-Date
while($true)
	{	
	while ( (Test-Connection $computername -Count 1 -BufferSize 1 -Quiet) )
		{
		$lapse = (get-date) - $starttime
		write-host "`r$lineNo" "Connectivity" $lapse.hours "hours" $lapse.minutes "minutes" $lapse.seconds "seconds    " -ForegroundColor Green -NoNewline 
		}
	Write-Host " "
	Write-Host (Get-Date -Format "MM-dd-yy hh:mm:ss" ) -ForegroundColor Yellow
	$starttime = Get-Date
	while ( (Test-Connection $computername -Count 1 -Quiet) -eq $false )
		{
		$lapse = (get-date) - $starttime
		write-host "`r$lineNo" "No Connectivity" $lapse.hours "hours" $lapse.minutes "minutes" $lapse.seconds "seconds    " -ForegroundColor Red -NoNewline
		}
	Write-Host " "
	Write-Host (Get-Date -Format "MM-dd-yy hh:mm:ss" ) -ForegroundColor Yellow
	$starttime = Get-Date
	}
