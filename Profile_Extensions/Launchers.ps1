Function Launch-Far
	{
	."C:\Program Files\Far Manager\Far.exe"
	}

Function Launch-Helpdesk
	{
	Start-Process "http://mishelp1:8080/WOListView.do?requestViewChanged=true&"
	}

Function Launch-SmartCare
	{
        param(
            [ValidateSet("Prod", "PreProd", "Train", "Setup", "QA")]
            $System="PROD"
            )
	Start-Process "https://lifepathsc.smartcarenet.com/LifePathSmartCare$($System)/SSO.aspx"
 	}
        
Function Launch-Anasazi
	{
	."C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfService.exe" -launch -reg "Software\Microsoft\Windows\CurrentVersion\Uninstall\lifepath-80143580@@XenApp6.5.Live Anasazi Central" -startmenuShortcut
        Get-XMLPassword -Name Anasazi -Type Password -AsPlainText $True | clip
        $null = Start-Job -ScriptBlock { sleep 30; "" | clip } 
	}

Function Launch-AssetInventory
	{
	Invoke-Item -Path "\\Misfs1\svcreq$\Request for Services.mdb"
	}

Function Launch-Paylocity
	{
	Start-Process "https://login.paylocity.com/Escher/Escher_WebUI/views/login/login.aspx"
	}

Function Enter-Clonezilla
	{
	Enter-SSHSession -User administrator -Hostname 192.168.103.254 -Password ( Get-XMLPassword -Name Clonezilla -Type Password -AsPlainText $True )
	}

Function Start-ScreenConnect($computer)
	{
	Start-Process "https://assist.lifepathsystems.org/Host#Access/All%20Machines/$computer"
	}

Function Manage-EqualLogic
	{
	."$Scripts\Java\groupmgr.jnlp"
	}

Function Launch-Video($VideoID)
	{
	$url = "https://www.youtube.com/embed/$VideoID"
    	#."C:\Program Files\VideoLAN\vlc\vlc.exe" $url
    	."C:\Users\wreeves\scoop\shims\mpv.exe" $url
       	}

Function Search-YouTube($query, $results=10,[switch]$VLC)
    {
    $params = @{
		type='video';
		q=$query;
                part='snippet';
                maxResults=$results;
                key='AIzaSyDTx7_0Xl09t4adX06h2pmJrsDVCqxtb1A'  
		}   

    $response = Invoke-RestMethod -Uri https://www.googleapis.com/youtube/v3/search -Body $params -Method Get
    for ( $i=1; $i -le $Response.items.count; $i++)
        {
        Write-Host "$i. $($response.items[$i-1].snippet.title)" -ForegroundColor Cyan
        }
    $Selection = Read-host "Selection"
    if ( $VLC )
        {
        Launch-Video -VideoID ($response.items[$selection-1].id.videoId) -VLC
        }
    else
        {
        Launch-Video -VideoID ($response.items[$selection-1].id.videoId)
        }
    }

Function Launch-CMBHS
	{
	Start-Process "https://cmbhs.dshs.state.tx.us/cmbhs/WebPages/Default.aspx"
	}

Function Launch-ChromeRemoteDesktop
	{
	."C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  --profile-directory=Default --app-id=gbchcmhmhahfdphkhkmpfmihenigjmpp
	}

Function Launch-DellSupport
	{
	Start-Process "http://www.dell.com/support/incidents-online/us/en/19/contactus/dynamic"
	}

Function Launch-MISSharePoint
	{
	Start-Process "http://sharepoint/sites/mis/_layouts/15/start.aspx#/"
	}

Function Launch-SharePoint
	{
	Start-Process "http://sharepoint"
	}
Function Launch-NextCloud
        {
        Start-Process "https://darthwayne.yourownnet.cloud:9543"
        }

Function SSH-Wayne
	{
        #kageant "C:\Users\wreeves\Documents\WayneKeyGen\WaynePriv.ppk"
	putty-url -load wayne
	}

Function SSH-Socks
	{
        #kageant "C:\Users\wreeves\Documents\WayneKeyGen\WaynePriv.ppk"
	putty-url -load wayne-SOCKS
	}

Function Select-AdministrativeTool
	{
	Param($Selection)
	Function Get-Selection
			{
			for ( $i=1;$i -le $Choices.count; $i++)
					{
					Write-Host "$i. $($Choices[$i-1].BaseName)" -ForegroundColor Cyan
					}
					$Selection = Read-Host "Selection"
					try
							{
							[int]$num = $Selection
							}
			Catch
							{
							Write-Host "Not a Valid Entry" -ForegroundColor Red
							}
					if ( $num -lt 1 -or $num -gt $Choices.count )
					{
					Write-Host "Not a Valid Entry" -ForegroundColor Red
					exit
					}
			$Selection = $Choices[$Selection-1]
			Return $Selection
			}
	$Choices = Get-ChildItem "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools"
	if ( $Selection -eq $null )
					{
					$Selection = Get-Selection
					}
	elseif ( $Selection -is [int] )
			{
			$Selection = $Choices[$Selection-1]
			}
	else
			{
			$Choices = $Choices | ? BaseName -match $Selection
			if ( $Choices.count -gt 1 )
					{
					$Selection = Get-Selection
					}
			else
					{
					$Selection = $Choices
					}
			}
	if ( $Selection.BaseName -eq "Remote Desktop Services" )
			{
			Write-Host "Launching $($Selection.BaseName)" -ForegroundColor Green
			ii $Selection.Fullname
			}
	else
			{
			Write-Host "Launching $($Selection.BaseName)" -ForegroundColor Green
			.($Selection.Fullname)
			#echo $Selection
			}
	}

Function Start-Countdown
    {
    param(
        [switch]$ShutDown,
        [string]$Time = "5:00PM",
        [string]$Message = "Go Home!"
        )
    $ClosingTime = Get-Date $Time
    while ( (Get-Date) -le $ClosingTime )
            {
            $Date = Get-Date 
            $Countdown = $ClosingTime - $Date
            Write-Host "`r$(Get-Date $Date -Format "hh:mm:ss") Countdown: -$($Countdown.Hours):$($Countdown.Minutes):$($Countdown.Seconds):$($Countdown.milliseconds)   " -ForegroundColor Yellow -NoNewLine
            }
    if ( $ShutDown )
        {   
        sd -f
        }
    else
        {
        Write-Host $Message -ForegroundColor Green
        }
    }

Function Launch-VisualTime
    {
    ."\\misfs1\Global\Meeting Room Scheduler\visualtime.exe" -URL=http://missched1/visualtime
    }

Function Launch-Radio
    {
    if ( Get-Process vlc -ErrorAction SilentlyContinue )
        {
        Write-Host "Killing Radio" -ForegroundColor Yellow
        Get-Process vlc | Stop-Process 
        }
    else
        {
        Write-Host "Launching Radio" -ForegroundColor Green
        ."C:\Program Files\VideoLAN\VLC\vlc.exe" -I null --play-and-exit "~/kxtlive128.m3u"
        }
    }

Function Launch-DefaultTabs
    {
    helpdesk; sleep -milliseconds 750
    screen; sleep  -milliseconds 750
    wiki
    }
