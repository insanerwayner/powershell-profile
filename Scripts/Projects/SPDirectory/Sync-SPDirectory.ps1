$session = New-PSSession -ComputerName DC01

#Load The Active Directory Module
Invoke-Command -Session $session -ScriptBlock { Import-Module ActiveDirectory }

# Retrieve the Get-ADUser cmdlet to your Session
Import-PSSession -Session $session -CommandName *-ADUser

# Add SharePoint.PowerShell Snapin
Add-PSSnapin Microsoft.SharePoint.PowerShell

# Retrieve Specific Web – In my case my Sharepoint Site was call Intranet
$spWeb = Get-SPWeb http://sharepoint

# Retrieve Specific List and delete all items in list – I created a list call Test# and then added Columns for Extension and Cell Phone
$spList = $spWeb.Lists["Test"]

# This command deletes all of the items on your list so that it starts fresh each time# and removed anything from AD that has been removed.  You could pull everything into# an array and then compare but I felt it would be faster to clear out the list# and then start from scratch each time.
#while ($splist.Items.Count -gt 0)
#    {
#    $splist.Items.Delete(0)
#    }

# Sync-This

$Items = $spList.Items

foreach ( $item in $items )
    {
    $User = Get-ADUser -Filter { SID -eq $Item[SID] }
    If ( $User )
        {
        If ( ( $Item[Extension] -ne $Null ) -and ( $Item[Extension] -ne $User.OfficePhone ) )
            {
            $User | Set-ADUser -OfficePhone $Item[Extension]
            }
        If ( ( $Item["Alternative Extension"] -ne $Null ) -and ( $Item["Alternative Extension"] -ne $User.MobilePhone ) )
            {
            $User | Set-ADUser -MobilePhone $Item["Alternative Extension"]
            }
        }
    Else
        {
        $Item.Delete()
        }
    }

# Add New Users

$Users = Get-ADUser -Filter * -SearchBase 'CN=users,DC=ccmhmr,DC=local' -Properties title, office, description | 
    Where { ( $_.Title -ne $Null ) -and ( $_.Office -ne $Null ) -and ( $_.Office -notmatch "Test" ) -and ( $_.Office -ne "Tarrant" ) -and ( $_.Office -notmatch "Telemed" ) 
        -and ( $_.Description -notmatch "Test" ) -and ( $_.GivenName -ne "Z" ) -and $_.Enabled }

Foreach ( $User in $Users )
    {
    If ( $Items | ? { $_[SID] -eq $User.SID )
        {
        Write-Console "User already exists"
        }
    else
        {
        if ( $User.GivenName -ceq $User.GivenName.ToLower() )
		{
		$GivenName = ToProperCase($User.GivenName)
		}
	else
		{
		$GivenName = $User.GivenName
		}
	
	if ( $User.SurName -ceq $User.SurName.ToLower() )
		{
		$SurName = ToProperCase($User.SurName)
		}
	else
		{
		$SurName = $User.SurName
		}

	$item = $splist.AddItem()
        $item["Full Name"] = $User.Name
	$item["First Name"] = $GivenName
	$item["Last Name"] = $SurName
	$item["Job Title"] = $User.Title
   	$item["Office"] = $User.Office
        $item["SID"] = $User.SID
	$item.Update()
        }
    }

Exit-PSSession
