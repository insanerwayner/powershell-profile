$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:Public\Desktop\Calc.lnk")
$Shortcut.TargetPath = "Calc"
$Shortcut.Save()