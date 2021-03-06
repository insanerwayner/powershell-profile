$dc = (get-WmiObject -Class win32_ntdomain -Filter "DomainName = 'ccmhmr'").DomainControllerName
$dc = $dc.Replace('\\','')
$Wmi = ([wmiclass]’Win32_Printer’)
$Wmi.Scope.Options.EnablePrivileges = $true
$printers = gwmi win32_printer -ComputerName $dc -Filter 'shared=true' -Credential $credential | foreach { $_.name }
return $printers
