Function Wake-BoardCloset
	{
	Send-WOL 48:4D:7E:CF:41:4A
	}

Function Get-VerseoftheDay
	{
        $Width = switch ($Host.UI.RawUI.BufferSize.Width) {
	    { 1..99 -contains $_ } { $_ }
	    { $_ -ge 100 } { 100 }
	    }
	$Scripture = (Get-BibleVerse -VerseOfTheDay -Type json | ConvertFrom-Json)[0] 
	$book = $Scripture.bookname 
	$chap = $Scripture.chapter 
	$verse = $Scripture.verse 
	$ref = $book+" "+$chap+":"+$verse
	$txt = ('"' + $Scripture.text + '"').replace(' "','"') -Replace "  ", " " | Wrap-Text -Width $Width
        #$txt = $Scripture.text | Wrap-Text -Width $Width
	$length = ($txt | Measure-Object -Maximum -Property Length).Maximum
	$space = " "*($length - $ref.length)
        $border = ("="*$($length)).substring(0, [System.Math]::Min(240, $length))
        Write-Host $border -ForegroundColor DarkGray
	$txt | % { Write-Host $_ -ForegroundColor White }
	Write-Host (" "*($length))
	Write-Host $space$ref -ForegroundColor Yellow
        Write-Host $border -ForegroundColor DarkGray
	}

Function Color-LS
    {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
          -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $fore = $Host.UI.RawUI.ForegroundColor
    $compressed = New-Object System.Text.RegularExpressions.Regex(
          '\.(zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
          '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
          '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)

    Invoke-Expression ("Get-ChildItem $args") | ForEach-Object {
        if ($_.GetType().Name -eq 'DirectoryInfo') 
            {
            $Host.UI.RawUI.ForegroundColor = 'Cyan'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
            }
        elseif ($compressed.IsMatch($_.Name)) 
            {
            $Host.UI.RawUI.ForegroundColor = 'DarkGreen'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
            }
        elseif ($executable.IsMatch($_.Name))
            {
            $Host.UI.RawUI.ForegroundColor = 'Yellow'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
            }
        elseif ($text_files.IsMatch($_.Name))
            {
            $Host.UI.RawUI.ForegroundColor = 'White'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
            Write-Host "_"
	    }
        else
            {
            echo $_
            }
        }
    }

Function Enter-SSHSession($Hostname,$User,$Password,$Port=22)
	{
	if ( $user -eq $null )
		{
		putty -ssh $hostname $Port
		}
	elseif ( $Password -eq $null )
		{
		putty -ssh $user@$hostname $Port
		}
	else
		{
		putty -ssh $user@$hostname -pw $Password $Port
		}
	}
Function Show-Desktop
	{
	(New-Object -ComObject shell.application).toggleDesktop()
	}	

Function Get-NewDCs
	{
	get-addomaincontroller -Filter { OperatingSystem -notlike "Windows Server 2003" -and OperatingSystem -notlike "Windows Server® 2008 Standard" }
	}

Function Sync-Files
	{
        param(
            [Switch]$Download
            )
        $destination='C:\Users\wreeves\OneDrive - Lifepath Systems\Documents'
        If ( !$Download )
            {
            Get-ChildItem $Docs\"Remote Assistance Logs" | Remove-Item -Confirm:$False
            robocopy C:\Users\wreeves\Documents $destination /MIR /FFT /XJ /Z /XA:H /W:5
	    robocopy C:\wsl\homebackups 'C:\Users\wreeves\OneDrive - Lifepath Systems\homebackups'
            }
        Else 
            {
            robocopy $destination C:\Users\wreeves\Documents /MIR /FFT /XJ /Z /XA:H /W:5
            }
	}

Function Get-UserVariable ($Name = '*')
	{
	# these variables may exist in certain environments (like ISE, or after use of foreach)
	$special = 'ps','psise','psunsupportedconsoleapplications', 'foreach', 'profile'
 	$ps = [PowerShell]::Create()
	$null = $ps.AddScript('$null=$host;Get-Variable') 
	$reserved = $ps.Invoke() |
 	Select-Object -ExpandProperty Name
	$ps.Runspace.Close()
	$ps.Dispose()
	Get-Variable -Scope Global |
	Where-Object Name -like $Name |
	Where-Object { $reserved -notcontains $_.Name } |
	Where-Object { $special -notcontains $_.Name } |
	Where-Object Name
	}

Function Get-FolderSize
	{
	param(
	[parameter(ValueFromPipelineByPropertyName)]
	$FullName = (pwd),
	[ValidateSet('TB', 'GB', 'MB', 'KB')]
	$Unit = "GB"
	)
	$munit = "1$($unit)"
	$item = Get-Item $Fullname
	$colitems = (Get-ChildItem $Fullname -R | Measure-Object -property length -sum)
	$item | Add-Member -MemberType NoteProperty -Name Size -Value ("{0:N2}" -f ($colItems.sum / $munit) + " $($unit)")
	$item | select Mode, LastWriteTime, Size, Name
	}

Function Get-WeatherPicture($City="75069") 
	{
	if ($City -eq $null)
		{
	        $City = Read-Host "Specify City"
	    	}
	(Invoke-WebRequest "http://wttr.in/$City" -UserAgent curl).content -split "`n"
	}

Function Suspend-Computer
	{
        Add-Type -AssemblyName System.Windows.Forms
	# 1. Define the power state you wish to set, from the
	#    System.Windows.Forms.PowerState enumeration.
	$PowerState = [System.Windows.Forms.PowerState]::Suspend;

	# 2. Choose whether or not to force the power state
	$Force = $false;

	# 3. Choose whether or not to disable wake capabilities
	$DisableWake = $false;

	# Set the power state
	[System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake);
	}

Function Get-WeekOfYear
	{
	Get-Date -UFormat %V
	}

Function Send-FileHome($FileName,$Destination)
	{
	pscp -P 2233 $filename wayne@darthwayne.duckdns.org:/home/wayne/$destination
	}

Function Get-IPInfo
    {
    param($ComputerName="$env:COMPUTERNAME")
    get-ciminstance win32_networkadapterconfiguration -computername $computername | 
        Where-Object { $_.ipaddress -ne $null } | 
            Select-Object Description, IPaddress, IPSubnet, DefaultIPGateway, DNSServerSearchOrder, DNSDomain, MacAddress
    }

Function Search-ArchWiki
    {
    param(
        [Parameter(Mandatory=$True)]
        [string]$Query
    )
    if ( $Query -ne $null )
        {
        $Query = $Query.Replace(" ","+")
        $URL = "https://wiki.archlinux.org/index.php?search=$($Query)&title=Special%3ASearch&profile=default&fulltext=1"
        }
    else
        {
        $URL = "https://wiki.archlinux.org"
        }
    Start-Process $URL
    }

Function Search-MISWiki
    {
    param(
            [Parameter(Mandatory=$False)]
            [string]$Query
         )
    if ( $Query -ne $null )
        {
        $Query = $Query.Replace(" ","+")
        $URL = "http://miswiki/doku.php?do=search&id=$($Query)"
        }
    else
        {
        $URL = "http://miswiki"
        }
    Start-Process $URL
    }

Function Reload-misModules
    {
    get-module mis* | remove-module | import-module
    }

Function Get-UserInfo
    {
    Param(
        [Parameter(
            Position=0
        )]
        [string]$Name,
        [Parameter(
            Position=1
        )]
        [string]$Title,
        [Parameter(
            Position=2
        )]
        [string]$Department,
        [Parameter(
            Position=3
        )]
        [string]$Office,
        [Parameter(
            Position=4
        )]
        [string]$Phone,
        [Parameter(
            Position=5
        )]
        [ValidateSet("Name","Title","Department","Office","Phone")]
        [string]$SortBy="Name",
        [Parameter(
            Position=6
        )]
        [switch]$Descending
    )
    If ( $Name )
        {
        $Name = "(|(name=*$($Name)*)(samaccountname=*$($Name)*))"
        }
    
    If ( $Department )
        {
        $Department = "(department=*$($Department)*)"
        }
    If ( $Title )
        {
        $Title = "(title=*$($Title)*)"
        }
    If ( $Office )
        {
        $Office = "(physicalDeliveryOfficeName=*$($Office)*)"
        }
    If ( $Phone )
        {
        $Phone = "(|(telephoneNumber=*$($Phone)*)(mobile=*$($Phone)*))"
        }
    If ( $Descending )
        {
        $Descending=$True
        }
    Else
        {
        $Descending=$False
        }
    $SearchString = "(&$($Name)$($Office)$($Department)$($Phone)$($Title)$($Phone))"
    Get-ADUser -ldapfilter $SearchString -Properties Office, Department, Title, MobilePhone, OfficePhone -Server dom01 | 
        Select-Object Name, Title, Department, Office, OfficePhone, MobilePhone | 
            Sort-Object -Property $SortBy -Descending:$Descending | Format-Table
    }

Function Send-Helpdesk
    {
    param(
        $User
        )
    $Body = @'
<h2 id="ways-to-submit-a-ticket-with-mis-in-order-of-preference">Ways to Submit a Ticket with MIS (in order of preference)</h2>
<ul>
<li><p>Use <strong>ManageEngine Service Desk</strong> on your desktop.</p></li>
<li><p>Send email to <strong>mis_helpdesk@lifepathsystems.org</strong></p></li>
<li><p><i>When the other two methods are unavailable or you are locked out</i>, Call Ext <strong>6199</strong> </p></li>
</ul>
'@
    $User = (Select-User $User).samaccountname
    Send-MailMessage -to "$($User)@lifepathsystems.org" -from "donotreply@lifepathsystems.local" -subject "How to Submit an MIS Request" -BodyAsHtml $Body -smtpserver MISEXCH01.ccmhmr.local
    }

Function Get-DefaultPrinter
    {
    param(
        $Computer
        )
    $Computer = (Select-Computer $Computer).Name
    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('currentuser', $Computer)
    $RegKey= $Reg.OpenSubKey('Software\Microsoft\Windows NT\CurrentVersion\Windows')
    $DefaultPrinter = $RegKey.GetValue("Device")
    $DefaultPrinter | ConvertFrom-Csv -Header Name, Provider, Order| Select Name
    }

Function Get-OutlookCalendar 
{ 
  <# 
   .Synopsis 
    This function returns appointment items from default Outlook profile 
   .Description 
    This function returns appointment items from default Outlook profile. It 
    uses the Outlook interop assembly to use the olFolderCalendar enumeration. 
    It creates a custom object consisting of Subject, Start, Duration, Location 
    for each appointment item.  
   .Example 
    Get-OutlookCalendar |  
    where-object { $_.start -gt [datetime]"5/10/2011" -AND $_.start -lt ` 
    [datetime]"5/17/2011" } | sort-object Duration 
    Displays subject, start, duration and location for all appointments that 
    occur between 5/10/11 and 5/17/11 and sorts by duration of the appointment. 
    The sort is shortest appointment on top.  
   .Notes 
    NAME:  Get-OutlookCalendar 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 05/10/2011 08:36:42 
    KEYWORDS: Microsoft Outlook, Office 
    HSG: HSG-05-24-2011 
   .Link 
     Http://www.ScriptingGuys.com/blog 
 #Requires -Version 2.0 
 #> 
 Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null 
 $olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]  
 $outlook = new-object -comobject outlook.application 
 $namespace = $outlook.GetNameSpace("MAPI") 
 $folder = $namespace.getDefaultFolder($olFolders::olFolderCalendar) 
 $folder.items | 
 Select-Object -Property Subject, Start, Duration, Location 
} #end function Get-OutlookCalendar

Function Get-UpcomingAppointments
    {
    param(
        [int]
        $DaysinAdvance = 1
        )
    $Today = Get-Date -Date (get-date).Date
    Get-OutlookCalendar | Where-Object { $_.Start -gt $Today -and $_.Start -le $Today.adddays($DaysinAdvance) }
    }

Function Clean-TempAndDownloads
    {
    "C:\Users\wreeves\Documents\Temp\", "C:\users\wreeves\Downloads\" | foreach `
        {
        $Folder = $_
        "*.jnlp", "SKM*.PDF", "*Mobile*.PDF", "phones.*report.html", "*.eml" | foreach `
            {
            $FileType = $_
            Get-ChildItem -Path (Join-Path $Folder $Filetype) | Remove-Item
            }
        }
    }

Function Open-RemoteFileWithVim
    {
    param(
        $FilePath
        )
    $FilePath = $FilePath.Replace("/","\")
    If ( !(Test-Path $FilePath) )
        {
        $FileName = $FilePath.Split("\") | Select-Object -Last 1
        $ParentPath = $Filepath.Trimend($FileName)
        $ParentPath = (Get-Item $ParentPath).FullName.Substring(0,$ParentPath.length -1)
        }
    Else
        {
        $FilePath = Get-Item $FilePath
        $ParentPath = $FilePath.Directory.FullName
        $FileName = $FilePath.Name
        }
    $TempDrive = New-PSDrive -Name W -PSProvider FileSystem -Root $ParentPath -Scope Global -Persist 
    $NewPath = Join-Path 'W:\' $FileName
    vim $NewPath
    Remove-PSDrive -Name W
    }


Function Wrap-Text 
    {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=1,ValueFromPipeline=1,ValueFromPipelineByPropertyName=1)]
        [Object[]]$Chunk,
        [int]$Width=$Host.UI.RawUI.BufferSize.Width
    )
    PROCESS 
        {
        $Lines = @()
        foreach ($line in $chunk) 
            {
            $str = ''
            $counter = 0
            $line -split '\s+' | % {
                $counter += $_.Length + 1
                if ($counter -gt $Width) {
                    $Lines += ,$str.trim()
                    $str = ''
                    $counter = $_.Length + 1
                    }
                $str = "$str$_ "
                }
            $Lines += ,$str.trim()
            }
        $Lines
        }
    }

Function New-RandomPasswordClipboard
    {
    $Password = New-RandomPassword
    $Password | clip
    "Your temporary password is: $($Password)" | cowsay
    }

Function Get-PassNotChangedCount
    {
    (get-aduser -filter * -properties passwordlastset -server dc02 | ? { $_.Enabled -eq $true -and $_.passwordlastset -eq $null } ).count
    }

Function Test-ADAuthentication 
    {
    param(
        $username,
        $password)
        
    (New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null
    }

Function Clean-Computer
    {
    sudo bleachbit.exe -c --preset
    }

function Set-DefaultBrowser
    {
    $regKey      = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\{0}\UserChoice"
    $FileAsocRegKey = "hkcu:\Software\Classes\{0}\OpenWithProgids"
    $regKeyHttp  = $regKey -f 'http'
    $regKeyHttps = $regKey -f 'https'
    $FileAssocHTM = $FileAssocRegKey -f '.htm'
    $FileAssocHTML = $FileAssocRegKey -f '.html'

    Set-ItemProperty $regKeyHttp  -name ProgId BraveHTML.ZCEUGB4EYGF3ID4KTQQLMBIMYE
    Set-ItemProperty $regKeyHttps -name ProgId BraveHTML.ZCEUGB4EYGF3ID4KTQQLMBIMYE
    } 
