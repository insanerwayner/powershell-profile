$domain = [Environment]::UserDomainName
$username = [Environment]::UserName

$User = [ADSI]("WinNT://" + $domain + "/" + $username)
$script = "\\" +$domain + "\netlogon\" + $User.LoginScript

Start-Process $script