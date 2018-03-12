param($PrinterName)
$dc = (get-WmiObject -Class win32_ntdomain -Filter "DomainName = 'ccmhmr'").DomainControllerName
$dc = $dc.Replace('\\','')
$printer = gwmi win32_printer -ComputerName $dc -Credential $Credential | ? { $_.Name -eq $PrinterName }
Return $printer
