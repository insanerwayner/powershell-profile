Function Set-HomeDirectory($alias, $Department, $Office)
        {
        $HDActivity = "HomeDirectory"
        Write-Progress -Activity $HDActivity -CurrentOperation "Creating Share: $SharePath"
        switch ($Department) 
            {
            Admin
                {
                $FileServer = "misfs1"
                $NewFolder = Join-Path "\\$FileServer\d`$\User Shares\" $alias
                $LocalPath = Join-Path "D:\User Shares\" $alias
                }
            BH 
                { 
                $FileServer = "misfs1"
                $NewFolder = Join-Path "\\$FileServer\d`$\User Shares\" $alias
                $LocalPath = Join-Path "D:\User Shares\" $alias
                }
            IDD 
                {
                if ( $office -match "Plano" )
                    {
                    $NoHome = $True
                    $Stop = $True
                    }
                else 
                    {
                    $FileServer = "misfs1"
                    $NewFolder = Join-Path "\\$($FileServer)\d`$\IDD Users\" $alias
                    $LocalPath = Join-Path "D:\IDD Users\" $alias
                    }
                } 
            ECI 
                { 
                $FileServer = "misfs1"
                $NewFolder = Join-Path "\\$($FileServer)\d`$\ECI USERS\" $alias
                $LocalPath = Join-Path "D:\ECI USERS\" $alias
                }
            Hotline { $NoHome = $True }
            }
            if ( !$NoHome )
                {
                $SharePath = "\\$($FileServer)\$($alias)"
                $UserObject | Add-Member -MemberType NoteProperty -Name HomeDirectory -Value $SharePath                
                #Write-Host "Creating Share: $SharePath" -ForegroundColor Yellow
                Write-Progress -Activity $HDActivity -CurrentOperation "Creating Share: $SharePath"
                New-Item $NewFolder -Type Directory | Out-Null
                $ScriptBlock = { param($LocalPath,$alias) Add-NTFSAccess -Path $LocalPath -Account "CCMHMR\$($alias)" -AccessRights Modify }
                Write-Progress -Activity $HDActivity -CurrentOperation "Setting File Permissions"
                Invoke-Command $ScriptBlock -ArgumentList $LocalPath, $alias -ComputerName $FileServer
                New-SMBShare $Name $alias $Path $LocalPath -FullAccess Everyone -CimSession $FileServer	| Out-Null
                #Write-Host "Setting N Drive to $SharePath" -ForegroundColor Yellow
                Write-Progress -Activity $HDActivity -CurrentOperation "Setting N Drive to $SharePath"	
                Set-AdUser -Identity $alias -HomeDirectory $SharePath -HomeDrive "N" -Server DC01
                Write-Progress -Activity $HDActivity -Completed
                }
            else
                {
                $UserObject | Add-Member -MemberType NoteProperty -Name HomeDirectory -Value "None"
                #Write-Host "No HomeDirectory for $alias" -ForegroundColor Yellow
                Write-Progress -Activity $HDActivity -Completed
                if ( $Stop )
                    {
                    #Write-Host "$alias is IDD Plano. You will have to go set up HomeDirectory in the Active Directory Users and Computers Console" -ForegroundColor Cyan
                    $UserObject.HomeDirectory = "Manually Setup"
                    }
                }
        }
