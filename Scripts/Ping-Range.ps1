param($NetworkName,$FirstIP,$LastIP,[switch]$ShowTable)
$n = $NetworkName
$l = [int]$LastIP
$sint = [int]$FirstIP



$tabName = "Results"

#Create Table object
$table = New-Object system.Data.DataTable $tabName

#Define Columns
$col1 = New-Object system.Data.DataColumn REACHABLE,([string])
$col2 = New-Object system.Data.DataColumn UNREACHABLE,([string])

#Add the Columns
$table.columns.add($col1)
$table.columns.add($col2)

do {
if (test-connection $n$sint -count 1 -buffersize 16 -erroraction stop -Quiet)
	{
	$ip = "$n$sint"
	try
		{
		$Hostname = [System.Net.Dns]::GetHostbyAddress($ip).hostname
		write-host "SUCCESSFUL: $ip[$hostname]" -ForegroundColor Green
		$reachable = $reachable + "$ip[$hostname]"
		$row = $table.NewRow()
		$row.REACHABLE = "$ip[$hostname]"
		#Add the row to the table
		$table.Rows.Add($row)
		}
	catch
		{
		write-host "SUCCESSFUL: $ip[HOSTNAME: UNRESOLVED]" -ForegroundColor Red
		$reachable = $reachable + "$ip[$hostname]" 
		$row = $table.NewRow()
		$row.REACHABLE = "$ip[HOSTNAME: UNRESOLVED]"
		#Add the row to the table
		$table.Rows.Add($row)
		}
	}
else
	{
	$ip = "$n$sint"
	Write-Host "UNREACHABLE $n$sint"
	$unreachable = $unreachable + "$ip"
	#Create a row
	$row = $table.NewRow()
	$row.UNREACHABLE = $ip 
	#Add the row to the table
	$table.Rows.Add($row)
	}
$sint++
}
while ($sint -le $l)

if ( $ShowTable)
    {
    #Display the table
    $table  | out-file c:\pingresults.txt
    notepad c:\pingresults.txt
    }

