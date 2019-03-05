$session = New-PSSession -ComputerName DomainControllerName.domain.com

#Load The Active Directory Module
Invoke-Command -Session $session -ScriptBlock { Import-Module ActiveDirectory }

# Retrieve the Get-ADUser cmdlet to your Session
Import-PSSession -Session $session -CommandName Get-ADUser

# Add SharePoint.PowerShell Snapin
Add-PSSnapin Microsoft.SharePoint.PowerShell

# Retrieve Specific Web – In my case my Sharepoint Site was call Intranet
$spWeb = Get-SPWeb http://intranet

# Retrieve Specific List and delete all items in list – I created a list call Test# and then added Columns for Extension and Cell Phone
$spList = $spWeb.Lists["Test"]
# This command deletes all of the items on your list so that it starts fresh each time# and removed anything from AD that has been removed.  You could pull everything into# an array and then compare but I felt it would be faster to clear out the list# and then start from scratch each time.
while($splist.Items.Count -gt 0){$splist.Items.Delete(0)}

# Get All Users and Create a new ListItem foreach user.
# All of our AD users have a street address of our company# so I filtered on a specific OU structure and filtered users# accounts that had a street address populated

Get-ADUser -Filter { streetAddress -like "*13616*" } -SearchBase 'OU=Lutz and Company,DC=lutzcpa,DC=com' -Properties * | ForEach-Object {
   $item = $spList.AddItem()
   $item["Title"] = $_.CN
   $item["Extension"] = $_.ipPhone
   $item["Cell Number"] = $_.mobile
   $item.Update()
 #You can comment the command out below when it is working.  This is just for testing.
   Write-Host "Item $($_.CN) Added to List"
 }
#Kill the Session when done
Exit-PSSession
