$null = New-PSDrive -Name HKU   -PSProvider Registry -Root Registry::HKEY_USERS

$children = Get-ChildItem HKU:\ | ? { $_.psiscontainer }

foreach ( $child in $children )
	{
	Write-Host "Setting" $child.name
	$path = $child.name.Replace('HKEY_USERS','HKU:')
	$fullpath = ( Join-Path $path 'Software\Fortinet\SslvpnClient\Tunnels\LPS' )
	Write-Host 
	New-Item $fullpath -Force
	New-ItemProperty $fullpath -Name 'Description' -Value 'Lifepath SSL VPN'
	New-ItemProperty $fullpath -Name 'Server' -Value 'connect.lifepathsystems.org'
	New-ItemProperty $fullpath -Name 'DATA1' -Value ''
	New-ItemProperty $fullpath -Name 'DATA3' -Value ''
	New-ItemProperty $fullpath -Name 'ServerCert' -Value '1'
	}