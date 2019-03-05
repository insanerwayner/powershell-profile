[CmdletBinding()]
param(
    $requester,
    $tech,
    [ValidateSet('Unlock', 'Reset', 'Retire')]
    $issue,
    $asset
    )
if ( !$tech ) 
    {
    Write-Host `
    "
    1. Connie
    2. Chad
    3. Melissa
    4. Wayne
    " -ForegroundColor Cyan
    $tech = Read-Host "Technician"
    switch ( $tech )
        {
        1 { $tech = "Connie" }
        2 { $tech = "Chad" }
        3 { $tech = "Melissa" }
        4 { $tech = "Wayne" }
        }
    }
switch ($tech) 
    { 
    "Chad" 
        {  
        $techname = "Chad Hickerson"
        $techkey = '3F40C808-FD88-49CC-A1CC-D027390976A6'
        }
    "Connie" 
        {
        $techname = "Connie Wilson"
        $techkey = '380D59DA-17EF-4341-9397-37319237D7AA'
        }
    "Melissa"
        {
        $techname = "Melissa Bolton"
        $techkey = '3079B86E-D5FC-40D2-AFA8-850A9F70A959'
        }
    "Wayne" 
        {
        $techname = "Wayne Reeves"
        $techkey = "92741403-5BF7-413B-998D-6F354C1DD900"
        }
    }

switch ( $issue )
    {
    "Unlock" { $Template = "Account Lockout - Network" }
    "Reset" { $Template = "Password Reset - Network" }
    "Retire" { $Template = "Ready Computer Asset for Auction" }
    }


$inputData = @"
<Operation>
<Details>
<Template>Ready Computer Asset for Auction</Template>
<requester>$requester</requester>
<priority>Normal</priority>
<location>Admin-McKinney- 1515 Heritage</location>
<On-call>N</On-call>
<technician>$techname</technician>
<UDF_LONG1>$Asset</UDF_LONG1>
<status>Open</status>
</Details>
</Operation>
"@


Function Close-Ticket($TicketID,$techkey)
    {
    $postParams = @{OPERATION_NAME='CLOSE_REQUEST';TECHNICIAN_KEY=$techkey}
    $uri = "http://mishelp1:8080/sdpapi/request/" + $($TicketID)
    $results = Invoke-WebRequest -Uri $uri -Method POST -Body $postParams
    #Write-Host $results.api.response.operation.result
    }


$postParams = @{OPERATION_NAME='ADD_REQUEST';TECHNICIAN_KEY=$techkey;INPUT_DATA=$inputData}

$results = Invoke-WebRequest -Uri http://mishelp1:8080/sdpapi/request -Method POST -Body $postParams
$xml = [xml]$results.content
$Status = $xml.api.response.operation.result.status
if ( $Status -eq "Success" )
    {
    Write-Host "Ticket Creation Status: $($Status)" -ForegroundColor Green
    $TicketID = $xml.api.response.operation.details.workorderid
    Write-Host "Closing Ticket: $($TicketID)" -ForegroundColor Green
    Sleep -Seconds 5
    Close-Ticket -TicketID $TicketID -techkey $techkey
    }
else
    {
    Write-Host "Ticket Creation Status: $($Status)" -ForegroundColor Red
    Write-Host ":( Something could have gone wrong with creating the ticket. Double check that it was created." -ForegroundColor Red
    }



