# Profile Extensions

Get-ChildItem ( Join-Path $home "Documents\WindowsPowerShell\Profile_Extensions" ) -File *".ps1" | ForEach-Object { . $_.FullName; Set-Variable -Name $_.basename -Value $_.FullName }

# Startup
Import-Module activedirectory
If ( Test-Connection MISHYPER01 -Quiet -Count 1 )
    {
    Import-Module Hyper-V -RequiredVersion 1.1
    }
If ( Test-Connection MISEXCH01 -Quiet -Count 1 )
    {
    Import-Module misExchange -DisableNameChecking
    }
If ( Test-Path $NetHome)
    {
    $null = Sync-Files
    }
If ( Test-Connection labs.bible.org -Quiet -Count 1 )
    {
    Get-VerseoftheDay
    }
Clean-TempAndDownloads

# Chocolatey Profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module posh-git
