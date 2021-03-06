function Out-Inventory($asset, $make, $serial, $model, $ufname, $ulname, $cpu, $ram, $order, $location, $type, $warrantydate, $comLicense, $OS)
{
	Function Connect-Database($Db, $Tables)
	{
	  $OpenStatic = 3
	  $LockOptimistic = 3
	  $connection = New-Object -ComObject ADODB.Connection
	  $connection.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$Db" )
	  Update-Records($Tables)
	} #End Connect-DataBase

	Function Update-Records($Tables)
	{
	  $RecordSet = new-object -ComObject ADODB.Recordset
	   ForEach($Table in $Tables)
	     {
	      $Query = "Select * from $Table"
	      $RecordSet.Open($Query, $Connection, $OpenStatic, $LockOptimistic)
	      Invoke-Expression "Update-$Table"
	      $RecordSet.Close()
	     }
	   $connection.Close()
	} #End Update-Records

	Function Update-InvInventory
	{
	 "Updating InvInventory"
	 $recordset.fields
	 $RecordSet.AddNew()
	 $RecordSet.Fields.Item("Asset_Tag") = $asset
	 $RecordSet.Fields.Item("Location") = $location
	 $RecordSet.Fields.Item("Type") = $type
	 $RecordSet.Fields.Item("Manufacturer") = $make
	 $RecordSet.Fields.Item("Serial_Number") = $serial
	 $RecordSet.Fields.Item("Model") = $model
	 $RecordSet.Fields.Item("Current_User_FName") = $ufname
	 $RecordSet.Fields.Item("Current_User_LName") = $ulname
	 $RecordSet.Fields.Item("CPU") = $cpu
	 $RecordSet.Fields.Item("Memory") = $ram
	 $RecordSet.Fields.Item("Build_Number") = $order
	 $RecordSet.Fields.Item("Warranty_Expire_Date") = $warrantydate
	 $RecordSet.Fields.Item("Comments") = $comLicense
	 $RecordSet.Update()
	} #End Update-InvInventory

	Function Update-InvSoftware
	{
	 "Updating InvSoftware"
	 $recordset.fields
	 $RecordSet.AddNew()
	 $RecordSet.Fields.Item("Asset_Tag") = $asset
	 $RecordSet.Fields.Item("OS") = $OS
	 $RecordSet.Update()
	} #End Update-InvSoftware

	Connect-Database -db "X:\Request for Services.mdb" -Tables "InvInventory", "InvSoftware"
}


#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.10.0
# Generated On: 8/13/2015 9:55 AM
# Generated By: wreeves
########################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$statusBar1 = New-Object System.Windows.Forms.StatusBar
$JoinBTN = New-Object System.Windows.Forms.Button
$PassLBL = New-Object System.Windows.Forms.Label
$PassTXT = New-Object System.Windows.Forms.TextBox
$keyTXT = New-Object System.Windows.Forms.TextBox
$UserTXT = New-Object System.Windows.Forms.TextBox
$OrderTXT = New-Object System.Windows.Forms.TextBox
$CompleteTXT = New-Object System.Windows.Forms.TextBox
$depBOX = New-Object System.Windows.Forms.ComboBox
$AssetTXT = New-Object System.Windows.Forms.TextBox
$keyLBL = New-Object System.Windows.Forms.Label
$UserLBL = New-Object System.Windows.Forms.Label
$OrderLBL = New-Object System.Windows.Forms.Label
$CompleteLBL = New-Object System.Windows.Forms.Label
$DepartLBL = New-Object System.Windows.Forms.Label
$AssetLBL = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$handler_statusBar1_PanelClick= 
{
#TODO: Place custom script here

}

$handler_OrderLBL_Click= 
{
#TODO: Place custom script here

}

$handler_textBox2_TextChanged= 
{
#TODO: Place custom script here

}

$handler_button1_Click= 
{
$statusBar1.text = "Processing"
#TODO: Place custom script here
## Create the unique control number 
$asset = $assetTXT.text
$completed = $CompleteTXT.text
$date = Get-Date -Format MM/dd/yy
$location = $depBOX.text
$serial = ( Get-WmiObject win32_BIOS ).serialnumber
$warrantydate = (.\get-dellwarranty.ps1 -servicetag $serial).enddate
$order = $OrderTXT.text
$User = $UserTXT.text
$ufname = ($user.split(" "))[0]
$ulname = ($user.split(" "))[1]
$key = $keyTXT.text
$comLicense = "Windows Key: " + $key
$make = ( Get-WMIObject win32_computersystem ).manufacturer
$model = ( Get-WMIObject win32_computersystem ).model
$OS = (Get-WmiObject win32_operatingsystem).Caption + (Get-WmiObject win32_operatingsystem).OSArchitecture
$list = import-csv prefixes.txt -Delimiter ";" | ? { $_.department -eq $location }
$prefix = $list.prefix
$name = $prefix + $asset
$pass = $PassTXT.text
$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("ccmhmr\administrator", $secpasswd)
$cpu = (get-wmiobject win32_processor).name
$RAM = (Get-WMIObject -class Win32_PhysicalMemory |
Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)}).tostring() + " GB"
$invpath = "\\misfs1\svcreq$"
#$csv = $asset + ".csv"
#$csvtxt = "asset,cpu,make,model,order,ram,serial,ufname,ulname
#$asset,$cpu,$make,$model,$order,$ram,$serial,$ufname,$ulname"
## Laptop? ##
$ou = $list.desktopou
$type = "Computer"
 if(Get-WmiObject -Class win32_systemenclosure | Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14})
   { $ou = $list.laptopou; $type = "Lap-Top" }
 if(Get-WmiObject -Class win32_battery ) 
   { $ou = $list.laptopou; $type = "Lap-Top" }
`
$statusBar1.text = "Connecting Mapped Drive"
#$scriptblock = {Param($content, $path) $content | Out-file -FilePath $path -Force }
#Invoke-Command -ScriptBlock $scriptblock  -ArgumentList $csvtxt, $csv -Credential (Get-Credential) -computername .
$net = new-object -ComObject WScript.Network
$net.RemoveNetworkDrive("X:")
$net.MapNetworkDrive("X:", $invpath, $false, "ccmhmr\administrator", $pass)
#$csvtxt | Out-File ( "X:\" + $csv ) -force
$statusBar1.text = "Writing to Inventory"
Out-Inventory -asset $asset -cpu $cpu -make $make -model $model -order $order -ram $ram -serial $serial -ufname $ufname -ulname $ulname -location $location -Type $type -warrantydate $warrantydate -comLicense $comLicense -os $os
$net.RemoveNetworkDrive("X:")
$statusBar1.text = "Removing Mapped Drive"


$statusBar1.text = "Writing Inventory Sheet"
### PDF Stamp ###
## Path to the PDF form you'd like to fill in 
$change_form = "Inventory Sheet.pdf" 
  


## The PDF that will be saved with the filled-in forms. 
## In my instance, the file is saved as the unique control number we use 
$output_file = "c:\" + $asset + ".pdf"
  
## Load the iTextSharp DLL to do all the heavy-lifting 
[System.Reflection.Assembly]::LoadFrom('itextsharp.dll') | Out-Null 
  
## Instantiate the PdfReader object to open the PDF 
$reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $change_form 
  
## Instantiate the PdfStamper object to insert the form fields to 
$stamper = New-Object iTextSharp.text.pdf.PdfStamper($reader,[System.IO.File]::Create($output_file)) 
  
## Create a hash table with all field names and properties 
$pdf_fields =@{ 
    'Asset Tag' =  $asset; 
    'Completed By' = $completed; 
    'Date' = $date; 
    'Location' = $location; 
    'Serial Number' = $serial; 
    'Order' = $order; 
    'Model' = $model;
	'User' = $User;
	'License' = $key
} 
  $pdf_fields
## Apply all hash table elements into the PDF form 
foreach ($field in $pdf_fields.GetEnumerator()) { 
    $stamper.AcroFields.SetField($field.Key, $field.Value) | Out-Null 
} 
  
## Close up shop 
$stamper.Close()

$statusBar1.text = "Join to domain as: $name"
$statusBar1.text = "Joining $name to domain"
$computer = Get-WmiObject Win32_ComputerSystem
$computer.joindomainorworkgroup( "ccmhmr.local", $pass, "administrator", $ou, 3)
$computer.Rename($name)
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
$OUTPUT= [System.Windows.Forms.MessageBox]::Show("Ready to restart?" , "Joined to Domain" , 4)
if ( $OUTPUT -eq "YES" )
	{
	$statusBar1.text = "Restarting Computer"
	Restart-Computer -Force
	}
else
	{
	$statusBar1.text = "Restart computer when ready"
	}
}


$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}

$PopulateList= 
{
    $dept = "prefixes.txt"
    import-csv $dept -Delimiter ";" | foreach ($_.department) {$depBOX.items.add($_.department.Trim())}
        }

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 225
$System_Drawing_Size.Width = 394
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "New Computer"
$form1.add_Load($PopulateList)

$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 203
$statusBar1.Location = $System_Drawing_Point
$statusBar1.Name = "statusBar1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 394
$statusBar1.Size = $System_Drawing_Size
$statusBar1.TabIndex = 17
$statusBar1.add_PanelClick($handler_statusBar1_PanelClick)

$form1.Controls.Add($statusBar1)

$PassLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$PassLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 178
$PassLBL.Location = $System_Drawing_Point
$PassLBL.Name = "PassLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 106
$PassLBL.Size = $System_Drawing_Size
$PassLBL.TabIndex = 16
$PassLBL.Text = "Password:"
$PassLBL.TextAlign = 4

$form1.Controls.Add($PassLBL)

$PassTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 175
$PassTXT.Location = $System_Drawing_Point
$PassTXT.Name = "PassTXT"
$PassTXT.PasswordChar = '*'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 261
$PassTXT.Size = $System_Drawing_Size
$PassTXT.TabIndex = 14
$PassTXT.add_TextChanged($handler_textBox2_TextChanged)

$form1.Controls.Add($PassTXT)


$JoinBTN.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 226
$System_Drawing_Point.Y = 12
$JoinBTN.Location = $System_Drawing_Point
$JoinBTN.Name = "JoinBTN"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 41
$JoinBTN.Size = $System_Drawing_Size
$JoinBTN.TabIndex = 13
$JoinBTN.Text = "Join"
$JoinBTN.UseVisualStyleBackColor = $True
$JoinBTN.add_Click($handler_button1_Click)

$form1.Controls.Add($JoinBTN)



$keyTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 149
$keyTXT.Location = $System_Drawing_Point
$keyTXT.Name = "keyTXT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 261
$keyTXT.Size = $System_Drawing_Size
$keyTXT.TabIndex = 11


$form1.Controls.Add($keyTXT)

$UserTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 122
$UserTXT.Location = $System_Drawing_Point
$UserTXT.Name = "UserTXT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 261
$UserTXT.Size = $System_Drawing_Size
$UserTXT.TabIndex = 10

$form1.Controls.Add($UserTXT)

$OrderTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 95
$OrderTXT.Location = $System_Drawing_Point
$OrderTXT.Name = "OrderTXT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 261
$OrderTXT.Size = $System_Drawing_Size
$OrderTXT.TabIndex = 9

$form1.Controls.Add($OrderTXT)

$CompleteTXT.AutoCompleteCustomSource.Add("Jack Locke")|Out-Null
$CompleteTXT.AutoCompleteCustomSource.Add("Melissa Bolton")|Out-Null
$CompleteTXT.AutoCompleteCustomSource.Add("Wayne Reeves")|Out-Null
$CompleteTXT.AutoCompleteCustomSource.Add("Connie Wilson")|Out-Null
$CompleteTXT.AutoCompleteCustomSource.Add("David Berk")|Out-Null
$CompleteTXT.AutoCompleteMode = 3
$CompleteTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 68
$CompleteTXT.Location = $System_Drawing_Point
$CompleteTXT.Name = "CompleteTXT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 261
$CompleteTXT.Size = $System_Drawing_Size
$CompleteTXT.TabIndex = 8

$form1.Controls.Add($CompleteTXT)

$depBOX.DataBindings.DefaultDataSourceUpdateMode = 0
$depBOX.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 41
$depBOX.Location = $System_Drawing_Point
$depBOX.Name = "depBOX"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 143
$depBOX.Size = $System_Drawing_Size
$depBOX.TabIndex = 12
$depBOX.add_SelectedIndexChanged($handler_depBOX_SelectedIndexChanged)

$form1.Controls.Add($depBOX)

$AssetTXT.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 124
$System_Drawing_Point.Y = 14
$AssetTXT.Location = $System_Drawing_Point
$AssetTXT.Name = "AssetTXT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 96
$AssetTXT.Size = $System_Drawing_Size
$AssetTXT.TabIndex = 6

$form1.Controls.Add($AssetTXT)

$keyLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$keyLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 152
$keyLBL.Location = $System_Drawing_Point
$keyLBL.Name = "keyLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 106
$keyLBL.Size = $System_Drawing_Size
$keyLBL.TabIndex = 5
$keyLBL.Text = "Windows Key:"
$keyLBL.TextAlign = 4

$form1.Controls.Add($keyLBL)

$UserLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$UserLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 124
$UserLBL.Location = $System_Drawing_Point
$UserLBL.Name = "UserLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 105
$UserLBL.Size = $System_Drawing_Size
$UserLBL.TabIndex = 4
$UserLBL.Text = "User Full Name:"
$UserLBL.TextAlign = 4

$form1.Controls.Add($UserLBL)

$OrderLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$OrderLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 95
$OrderLBL.Location = $System_Drawing_Point
$OrderLBL.Name = "OrderLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 106
$OrderLBL.Size = $System_Drawing_Size
$OrderLBL.TabIndex = 3
$OrderLBL.Text = "Order Number:"
$OrderLBL.TextAlign = 4
$OrderLBL.add_Click($handler_OrderLBL_Click)

$form1.Controls.Add($OrderLBL)

$CompleteLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$CompleteLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 70
$CompleteLBL.Location = $System_Drawing_Point
$CompleteLBL.Name = "CompleteLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 105
$CompleteLBL.Size = $System_Drawing_Size
$CompleteLBL.TabIndex = 2
$CompleteLBL.Text = "Completed By:"
$CompleteLBL.TextAlign = 4

$form1.Controls.Add($CompleteLBL)

$DepartLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$DepartLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 43
$DepartLBL.Location = $System_Drawing_Point
$DepartLBL.Name = "DepartLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 105
$DepartLBL.Size = $System_Drawing_Size
$DepartLBL.TabIndex = 1
$DepartLBL.Text = "Department:"
$DepartLBL.TextAlign = 4

$form1.Controls.Add($DepartLBL)

$AssetLBL.DataBindings.DefaultDataSourceUpdateMode = 0
$AssetLBL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 16
$AssetLBL.Location = $System_Drawing_Point
$AssetLBL.Name = "AssetLBL"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 105
$AssetLBL.Size = $System_Drawing_Size
$AssetLBL.TabIndex = 0
$AssetLBL.Text = "Asset Tag:"
$AssetLBL.TextAlign = 4

$form1.Controls.Add($AssetLBL)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
