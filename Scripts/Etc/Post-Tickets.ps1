$users = Get-Content c:\scripts\userstobeadded.txt
$Password = Read-Host "Password"
foreach ( $user in $users )
	{
	$Subject = "Create User -" + $user
	$postParams = @{
					operation='AddRequest';
					'Asset tag'='0';
					'Callback phone #'='0';
					Location='Admin-McKinney- 1515 Heritage';
					subject=$subject;
					description='Create User in AD';
					Mode='Web Form'
					category='User Administration';
					subcategory='User Joining';
					technicianemail='wreeves@lifepathsystems.org';
					username='wreeves';
					password=$password;
					DOMAIN_NAME='CCMHMR';
					logonDomainName='AD_AUTH'
					}
	Invoke-WebRequest -Uri http://mishelp1:8080/servlets/RequestServlet -Method POST -Body $postParams
	}
