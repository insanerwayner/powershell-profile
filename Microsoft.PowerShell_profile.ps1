# Profile Extensions
$env:HOME = "C:\Users\wreeves"
$ENV:STARSHIP_CONFIG = "$HOME\.starship\config.toml"
cd ~
If ( $Host.Version.Major -eq 7 )
	{
	Import-Module activedirectory, PoshKeePass -UseWindowsPowershell -WarningAction SilentlyContinue
	Set-PSReadLineOption -PredictionSource History
	$PSStyle.Formatting.TableHeader = $PSStyle.Foreground.BrightYellow + $PSStyle.Bold
	$PSStyle.Formatting.FormatAccent = $PSStyle.ForeGround.BrightYellow + $PSStyle.Bold
	$PSStyle.Formatting.Error = $PSStyle.ForeGround.Yellow + $PSStyle.Bold
	set-psreadlineoption -ContinuationPrompt ';  '
	}
Get-ChildItem ( Join-Path $home "Documents\WindowsPowerShell\Profile_Extensions" ) -File *".ps1" | `
	ForEach-Object { . $_.FullName; Set-Variable -Name $_.basename -Value $_.FullName }

# PSReadline
Set-PSReadlineOption -editmode vi

# Startup
If ( Test-Path $NetHome )
    {
    $scriptblock = { 
            Get-ChildItem $Docs\"Remote Assistance Logs" | Remove-Item -Confirm:$False
            robocopy C:\Users\wreeves\Documents \\misfs1\wreeves\Documents /MIR /FFT /Z /XA:H /W:5
	}
    $Null = Start-Job -Scriptblock $scriptblock -Name SyncFiles
    }
If ( Test-Connection labs.bible.org -Quiet -Count 1 )
    {
    Get-VerseoftheDay
    }
## CD-extras
$cde = @{
	AUTO_CD = $true
	ColorCompletion = $true
}
Import-Module cd-extras, posh-git
Clean-TempAndDownloads

# Chocolatey Profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#Import-Module posh-git
#Set-DefaultBrowser
Invoke-Expression (&starship init powershell)
