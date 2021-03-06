Param(
        # Name should be a valid computer name or IP address.
        [Parameter(Mandatory=$False, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false)]
        
        [Alias('HostName', 'Identity', 'DNSHostName', 'ComputerName')]
        [string[]]$Name,
        
         # ServiceTag should be a valid Dell Service tag. Enter one or more values.
         [Parameter(Mandatory=$false, 
                    ValueFromPipeline=$false)]
         [string[]]$ServiceTag
         )

    Begin{
         }
    Process{
        if($ServiceTag -eq $Null){
            foreach($C in $Name){
                $test = Test-Connection -ComputerName $c -Count 1 -Quiet
                    if($test -eq $true){
                        $service = New-WebServiceProxy -Uri http://xserv.dell.com/services/assetservice.asmx?WSDL
                        $system = Get-WmiObject -ComputerName $C win32_bios -ErrorAction SilentlyContinue
                        $serial =  $system.serialnumber
                        $guid = [guid]::NewGuid()
                        $info = $service.GetAssetInformation($guid,'check_warranty.ps1',$serial)
                        
                        $Result=@{
                        'ComputerName'=$c
                        'ServiceLevel'=$info[0].Entitlements[0].ServiceLevelDescription.ToString()
                        'EndDate'=$info[0].Entitlements[0].EndDate.ToShortDateString()
                        'StartDate'=$info[0].Entitlements[0].StartDate.ToShortDateString()
                        'DaysLeft'=$info[0].Entitlements[0].DaysLeft
                        'ServiceTag'=$info[0].AssetHeaderData.ServiceTag
                        'Type'=$info[0].AssetHeaderData.SystemType
                        'Model'=$info[0].AssetHeaderData.SystemModel
                        'ShipDate'=$info[0].AssetHeaderData.SystemShipDate.ToShortDateString()
                        }
                    
                        $obj = New-Object -TypeName psobject -Property $result
                        Write-Output $obj
                   
                        $Result=$Null
                        $system=$Null
                        $serial = $null
                        $guid=$Null
                        $service=$Null
                        $info=$Null
                        $test=$Null 
                        $c=$Null
                    } 
                    else{
                        Write-Warning "$c is offline"
                        $c=$Null
                        }        

                }
        }
        elseif($ServiceTag -ne $Null){
            foreach($s in $ServiceTag){
                        $service = New-WebServiceProxy -Uri http://xserv.dell.com/services/assetservice.asmx?WSDL
                        $guid = [guid]::NewGuid()
                        $info = $service.GetAssetInformation($guid,'check_warranty.ps1',$S)
                        
                        if($info -ne $Null){
                        
                            $Result=@{
                            'ServiceLevel'=$info[0].Entitlements[0].ServiceLevelDescription.ToString()
                            'EndDate'=$info[0].Entitlements[0].EndDate.ToShortDateString()
                            'StartDate'=$info[0].Entitlements[0].StartDate.ToShortDateString()
                            'DaysLeft'=$info[0].Entitlements[0].DaysLeft
                            'ServiceTag'=$info[0].AssetHeaderData.ServiceTag
                            'Type'=$info[0].AssetHeaderData.SystemType
                            'Model'=$info[0].AssetHeaderData.SystemModel
                            'ShipDate'=$info[0].AssetHeaderData.SystemShipDate.ToShortDateString()
                            }
                        }
                        else{
                        Write-Warning "$S is not a valid Dell Service Tag."
                        }
                    
                        $obj = New-Object -TypeName psobject -Property $result
                        Write-Output $obj
                   
                        $Result=$Null
                        $system=$Null
                        $serial=$Null
                        $guid=$Null
                        $service=$Null
                        $s=$Null
                        $info=$Null
                        
                   }
            }
    }
    End
    {
    }