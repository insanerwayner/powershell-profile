param([string]$start,[string]$end)
if ( ( $start -and !($start -as [DateTime]) ) -or ( $end -and !($end -as [DateTime]) ) )
	{
	Write-Host "Must enter valid DateTime Format" -ForegroundColor Red
	exit
	}
Function Get-LastDayOfMonth($date) 
	{
	return ((Get-Date ((((Get-Date $date).AddMonths(1)).Month).ToString() + "/1/" + (((Get-Date $date).AddMonths(1)).Year).ToString()))) - (New-TimeSpan -seconds 1)
	}

Set-Variable -name dayOfWeekLine -option Constant -value " Su Mo Tu We Th Fr Sa "
if ($start -eq "" -and $end -eq "") 
	{
	$startDate = Get-Date
	$endDate = Get-Date
	$startday = get-date -format dd
	$startmonth = Get-Date -Format MMMM
	$endday = "XX"
	$endmonth = "XX"
	}
elseif ($start -eq "") 
	{
	$startDate = Get-Date
	$endDate = Get-Date $end
	$startday = get-date -format dd
	$startmonth = Get-Date -Format MMMM
	$endday = Get-Date $end -Format dd
	$endmonth = Get-Date $end -Format MMMM
	}  
elseif ($end -eq "") 
	{
	$startDate = Get-Date $start
	$endDate = Get-Date $start
	$startday = get-date $start -format dd
	$startmonth = Get-Date $start -Format MMMM
	$endday = "XX"
	$endmonth = "XX"
	} 
else 
	{
	$startDate = Get-Date $start
	$endDate = Get-Date $end
	$startday = get-date $start -format dd
	$startmonth = Get-Date -Format MMMM
	$endday = Get-Date $end -Format dd
	$endmonth = Get-Date $end -Format MMMM
	}
if ($startDate -gt $endDate) 
	{
	Write-Warning "The Start Date must be earlier than the End Date"
	exit
	}
$month = $startDate
Write-Host ""
while ($month -le $endDate) 
	{
	 $firstDayOfMonth = Get-Date ((((Get-Date $month).Month).ToString() + "/1/" + ((Get-Date $month).Year).ToString() + " 00:00:00"))
	 $lastDayOfMonth = Get-LastDayOfMonth $firstDayOfMonth
	 $day = $firstDayOfMonth
	 $headline = ((Get-Date $firstDayOfMonth -Format MMMM) + " " + $firstDayOfMonth.Year)
	 Write-Host (" " * (($dayOfWeekLine.Length - $headline.Length) / 2)) -noNewline
	 Write-Host $headline -ForegroundColor Magenta
	 Write-Host $dayOfWeekLine -ForegroundColor Cyan
	 while ($day -le $lastDayOfMonth) 
		{
	    if ($day.day -eq 1 -and $day.DayOfWeek -ne "Sunday") 
			{
			Write-Host " " -noNewline
			if ($day.DayOfWeek -eq "Saturday") 
				{
				Write-Host (" " * 17) -noNewline
				} 
			elseif ($day.DayOfWeek -eq "Friday") 
				{
				Write-Host (" " * 14) -noNewline
				} 
			elseif ($day.DayOfWeek -eq "Thursday") 
				{
				Write-Host (" " * 11) -noNewline
				} 
			elseif ($day.DayOfWeek -eq "Wednesday") 
				{
				Write-Host (" " * 8) -noNewline
				} 
			elseif ($day.DayOfWeek -eq "Tuesday") 
				{
				Write-Host (" " * 5) -noNewline
				}
				elseif ($day.DayOfWeek -eq "Monday") 
				{
				Write-Host (" " * 2) -noNewline
				}
			}
	  if ( ( $day -match $startday -and (Get-Date $firstDayOfMonth -Format MMMM) -eq $startmonth ) -or ( $day -match $endday -and (Get-Date $firstDayOfMonth -Format MMMM) -eq $endmonth ) )
  		{
		if ($day.DayOfWeek -eq "Saturday") 
			{
    		Write-Host (" " + (Get-Date $day -Format dd)) -ForegroundColor Green
    		} 
		else 
			{
    		Write-Host (" " + (Get-Date $day -Format dd)) -noNewline -ForegroundColor Green
    		}
		}
	  else
  		{
  		if ($day.DayOfWeek -eq "Saturday") 
			{
    		Write-Host (" " + (Get-Date $day -Format dd)) -ForegroundColor White
    		} 
		else 
			{
    		Write-Host (" " + (Get-Date $day -Format dd)) -noNewline -ForegroundColor White
    		}
		}
	  $day = $day.AddDays(1)
	  }
	  if ($day.DayOfWeek -ne "Sunday") 
		{
		Write-Host ""
		}
	  Write-Host ""
	  $month = $firstDayOfMonth.AddMonths(1)
	}