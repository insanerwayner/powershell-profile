#add-pssnapin Microsoft.Exchange.Management.PowerShell.Admin
import-module activedirectory
Add-Type -AssemblyName Microsoft.VisualBasic
$userinformation = Import-Csv c:\autousers\table.csv
$email = $userinformation.email
$alias = $userinformation.alias
$db = $userinformation.db
$ou = $userinformation.ou
$FullN = [Microsoft.VisualBasic.Strings]::StrConv($userinformation.fulln,'ProperCase') 
$FirstN = [Microsoft.VisualBasic.Strings]::StrConv($userinformation.firstn,'ProperCase') 
$MI = $userinformation.mi.toupper()
$LastN = [Microsoft.VisualBasic.Strings]::StrConv($userinformation.lastn,'ProperCase') 
$cemail = $userinformation.cemail
$semail = $userinformation.semail
$creator = $userinformation.creator
$password = "Welcome1"
$securepassword = $Password = ConvertTo-SecureString -AsPlainText $Password -Force
$date = get-date
$logpath = "c:\autousers\logs.csv"
$errorpath = "c:\autousers\errors.txt"
$angels = "@acp.local"
$angelsemail = "@angelsofcare.com"
$west1 = "@west-1.com"


function ErrorMessage
{
$message = "User creation has failed for Employee: $fulln. An IT Ticket has already been submitted and will be reviewed by the IT staff as soon as possible. Thanks."
	write-host $message
	send-mailmessage -to $cemail -subject "User Creation Failed for $fulln" -body $message -from itsupport@angelsofcare.com -smtpserver server3bl.acp.local
	$message = "User creation has failed for Employee: $fulln Database: $db OU: $ou. Creator: $creator With Error: $error"
	send-mailmessage -to itsupport@angelsofcare.com -subject "User Creation Failed for $fulln" -body $message -from $cemail -smtpserver server3bl.acp.local
    "$date,$creator,$FullN,$alias,$db,$ou,FAILED" | out-file $logpath -append
    "$date, $FullN error:
    $error.FullyQualifiedErrorID
    "| out-file $errorpath -append
}
function createmailbox
{
New-mailbox -UserPrincipalName $alias$angels -alias $alias -database $db -Name $fulln -OrganizationalUnit $ou -password $Password -FirstName $firstn -LastName $lastn -DisplayName $fulln -ResetPasswordOnNextLogon $true -erroraction stop
Set-CASMailbox -Identity $alias -ActiveSyncEnabled $false
}

function west-1
{
$westmail = "$alias$west1"
set-mailbox $alias -emailaddresses SMTP:$westmail -emailaddresspolicyenabled $false
#Set-User -Identity $alias -ChangePasswordAtNextLogon $false

#SEND WEST-1 EMAIL	
$message = "The user $fulln has been created by $creator. Their login is: $alias and their Password is Welcome1 Their email address is $westmail."
write-host $message
send-mailmessage -to $cemail -cc $semail -subject "User Creation Successful for $fulln" -body $message -from itsupport@angelsofcare.com -smtpserver server3bl.acp.local
"$date,$creator,$FullN,$alias,$db,$ou,SUCCEEDED" | out-file $logpath -append
}

function aocemail
{
set-aduser $alias -homedirectory \\acp.local\aoc_data\data\Profiles\$alias -homedrive u:
$message = "The user $fulln has been created by $creator. Their login is: $alias and their First Time Password is Welcome1 Their email address is $email."
write-host $message
send-mailmessage -to $cemail -cc $semail -subject "User Creation Successful for $fulln" -body $message -from itsupport@angelsofcare.com -smtpserver server3bl.acp.local
"$date,$creator,$FullN,$alias,$db,$ou,SUCCEEDED" | out-file $logpath -append
Add-MailboxPermission $alias -User "Email Backup Management"
}

function addpermissions
{
Get-Content c:\autousers\permissions\$ou.txt | foreach{ get-adgroup -filter {name -eq $_} | add-adgroupmember -members $alias}
}

function createuser
{
$User = Get-ADUser -LDAPFilter "(sAMAccountName=$alias)"
If ($User -eq $Null) {
write-host "User Does Not Exist in AD"
	try
	{
	createmailbox
		if ($db -match "West-1")
		{
		addpermissions
		west-1
		}
		else
		{
		addpermissions
		aocemail
		}
    }
	catch
	{
	errormessage
	}
}
Else {
write-host "User Exists in AD $alias"
#TRY TO ADD MIDDLE INITIAL TO ALIAS
$alias = $FirstN.toLower().substring(0,1)+$MI.tolower()+$LastN.tolower()
$email = "$alias$angelsemail"
$FirstN = "$FirstN $MI"
$FullN = "$FirstN $LastN"
$User = Get-ADUser -LDAPFilter "(sAMAccountName=$alias)"
	If ($User -eq $Null) {
    write-host "User Does Not Exist in AD $alias"
		try
		{
		createmailbox
			if ($db -match "West-1")
			{
			addpermissions
			west-1
			}
			else
			{
			addpermissions
			aocemail
			}
		}
		catch
		{
		errormessage
		}
	}
	else{
    write-host "User Already Exists in AD"
		#TRY TO HAVE FULL NAME AS ALIAS
        $alias = $FirstN.tolower()+$LastN.tolower() -replace '\s+', ''
		$email = "$alias$angelsemail"
        $User = Get-ADUser -LDAPFilter "(sAMAccountName=$alias)"
			If ($User -eq $Null) 
			{
            write-host "User Does not Exist in AD $alias"
				try
				{
				createmailbox
					if ($db -match "West-1")
					{
					addpermissions
					west-1
					}
					else
					{
					addpermissions
					aocemail
					}
				}
				catch
				{
				errormessage
				}
			}
            else{
            write-host "User Already Exists in AD"
            errormessage
            }
	}
}
}

createuser
exit












