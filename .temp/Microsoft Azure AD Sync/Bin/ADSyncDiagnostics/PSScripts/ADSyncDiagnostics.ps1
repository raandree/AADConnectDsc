#-------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation.  All rights reserved.
#-------------------------------------------------------------------------

#
# Event IDs
#
Set-Variable -Option Constant -Scope script -Name EventIdDiagnosticsReportRun  -Value 3001
Set-Variable -Option Constant -Scope script -Name EventIdDiagnosticsReportEnd  -Value 3002
Set-Variable -Option Constant -Scope script -Name EventIdDiagnosticsReportFail -Value 3003

#
# Event Messages
#
Set-Variable -Option Constant -Scope script -Name EventMsgDiagnosticsReportRun  -Value "`r`nData collection has been started."
Set-Variable -Option Constant -Scope script -Name EventMsgDiagnosticsReportEnd  -Value "`r`nData collection finished successfully. `r`n{0}"
Set-Variable -Option Constant -Scope script -Name EventMsgDiagnosticsReportFail -Value "`r`nData collection terminated with an error. `r`n{0}"


#-------------------------------------------------------------------------
# 
# Helper functions to run AADConnect Diagnostics Report.
#
#-------------------------------------------------------------------------

#
# Outputs Windows Server OS information
#
Function Get-ADSyncDiagsServerOS
{
    $adSyncServername = $env:computername
    $adSyncOS = Get-WmiObject -class Win32_OperatingSystem -computername $adSyncServername

    $adSyncOSa = @()
    $row = "" | select ComputerName,Description,Caption,Version,BuildNumber,ServicePackMinorVersion,ServicePackMajorVersion,OSLanguage,OSArchitecture,Locale,CodeSet,LastBootUpTime,InstallDate
    $row.ComputerName = $adSyncServername
    $row.Description = $adSyncOS.Description
    $row.Caption = $adSyncOS.Caption
    $row.Version = $adSyncOS.Version
    $row.BuildNumber = $adSyncOS.BuildNumber
    $row.ServicePackMinorVersion = $adSyncOS.ServicePackMinorVersion
    $row.ServicePackMajorVersion = $adSyncOS.ServicePackMajorVersion
    $row.OSArchitecture = $adSyncOS.OSArchitecture
    $row.OSLanguage = $adSyncOS.OSLanguage
    $row.Locale = $adSyncOS.Locale
    $row.CodeSet = $adSyncOS.CodeSet
    $row.LastBootUpTime = $adSyncOS.LastBootUpTime
    $row.InstallDate = $adSyncOS.InstallDate
    $adSyncOSa += $row

    return $adSyncOSa
}

#-------------------------------------------------------------------------
# 
# Helper function to initialize AADConnect Diagnostics Report.
#
#-------------------------------------------------------------------------
Function Initialize-ADSyncDiagnosticsPath
{
    param
    (
        [parameter(mandatory=$true)]
        $OutputPath
    )

    if (-not $(Test-Path $OutputPath))
    {
        try 
        {
            $resultFolder = mkdir -Path $OutputPath -ErrorAction Stop
            return $true
        }
        catch       
        {
            $resultMsg = "An error occurred while creating the folder $OutputPath for AADConnect Diagnostics: $($_.Exception.Message)"
            WriteEventLog($EventIdDiagnosticsReportFail)($EventMsgDiagnosticsReportFail -f $resultMsg)
            Write-Error $resultMsg
            return $false
        }
    }
    else
    {
        return $true
    }
}

Function Initialize-ADSyncDiagnosticsText
{
    $Global:ADSyncDiagsTextReport = $null

    $culture = New-Object System.Globalization.CultureInfo 'en-us'
    $dateLocal = $((Get-Date).DateTime).ToString($culture)
    $date = $((Get-Date).ToUniversalTime()).ToString($culture)
    $Global:ADSyncDiagsTextReport = "AAD Connect Diagnostics`r`n"
    $Global:ADSyncDiagsTextReport += "$date (UTC)`r`n"
    $Global:ADSyncDiagsTextReport += "$dateLocal (Local)`r`n"
    $Global:ADSyncDiagsTextReport += "`r`n`r`n`r`n"
}

Function Initialize-ADSyncDiagnosticsHtml
{
    $Global:ADSyncDiagsHtmlReport = $null   
    $Global:ADSyncDiagsHtmlReport = @"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>AAD Connect Diagnostics Report</title>
<style>
p{ line-height: 1em; }
h1, h2, h3, h4{
    color: DodgerBlue;
	font-weight: normal;
	line-height: 1.1em;
	margin: 0 0 .5em 0;
}
h1{ font-size: 1.7em; }
h2{ font-size: 1.5em; }
a{
	color: black;
	text-decoration: none;
}
	a:hover,
	a:active{ text-decoration: underline; }
body{
    font-family: arial; font-size: 80%; line-height: 1.2em; width: 100%; margin: 0; background: white;
}
</style>
</head><body>
"@
    $dateUTC = [string] "$((Get-Date).ToUniversalTime().DateTime) (UTC)"
    $dateLocal = [string] "$((Get-Date).DateTime) (Local)"
    $Global:ADSyncDiagsHtmlReport += "<H1>AAD Connect Diagnostics on $($env:computername)</H1>"
    $Global:ADSyncDiagsHtmlReport += "<p>$dateLocal</p>"
    $Global:ADSyncDiagsHtmlReport += "<p>$dateUTC </p>"
}

#-------------------------------------------------------------------------
#
# Helper function to extend content of AADConnect Diagnostics Report.
#
#-------------------------------------------------------------------------
Function Add-ADSyncDiagnosticsText
{
    param
    (
        [parameter(mandatory=$false)]
        $Title,
        [parameter(mandatory=$false)]
        $AppendObject
    )

    if ($Title -ne $null)
    {
        $Global:ADSyncDiagsTextReport += "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" 
        $Global:ADSyncDiagsTextReport += "`r`n"
        $Global:ADSyncDiagsTextReport += $Title
        $Global:ADSyncDiagsTextReport += "`r`n"
        $Global:ADSyncDiagsTextReport += "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        $Global:ADSyncDiagsTextReport += "`r`n"
    }
    
    if ($AppendObject -ne $null)
    {
        $Global:ADSyncDiagsTextReport += $AppendObject | Out-String
    }
}

Function Add-ADSyncDiagnosticsHtml
{
    param(
        [parameter(mandatory=$false)]
        $Title,
        [parameter(mandatory=$false)]
        $HeadingSize="H2",
        [parameter(mandatory=$false)]
        $AppendObject,
        [ValidateSet("List","Table","String")]
        $Format="Table"
    )
    
    if ($Title -ne $null)  
    {
        $Global:ADSyncDiagsHtmlReport += "<$HeadingSize>$Title</$HeadingSize>`r`n"
    }
    
    if ($AppendObject -ne "")
    {
        if ($Format -like "String")  
        {
            $Global:ADSyncDiagsHtmlReport += "<p>$AppendObject</p>`r`n"
        }
        else  
        {
            $Global:ADSyncDiagsHtmlReport += $AppendObject | ConvertTo-Html -Fragment -As $Format
        }
        $Global:ADSyncDiagsHtmlReport += "<p></p>`r`n"
    }
} 

#-------------------------------------------------------------------------
# 
# Helper function to export AADConnect Diagnostics Report into a file.
#
#-------------------------------------------------------------------------
Function Export-ADSyncDiagnosticsText
{
    param
    (
        [parameter(mandatory=$true)]
        $Title,
        [parameter(mandatory=$true)]
        $ReportDate,
        [parameter(mandatory=$true)]
        $OutputPath
    )

    $filename = "$OutputPath\$($ReportDate)_$Title.log"
    try 
    {
        $Global:ADSyncDiagsTextReport | Out-String | Out-File -FilePath $filename -ErrorAction Stop

        $resultMsg = "AAD Connect Diagnostics Text Report is available at: `n$filename `n" 
        $resultMsg | Write-Host -ForegroundColor Green
    }
    catch  
    {
        $resultMsg = "An error occurred while exporting AADConnect Diagnostics to $filename : $($_.Exception.Message)"
        WriteEventLog($EventIdDiagnosticsReportFail)($EventMsgDiagnosticsReportFail -f $resultMsg)
        Write-Error $resultMsg
    }

    return  $resultMsg
}

Function Export-ADSyncDiagnosticsHtml
{
    param
    (
        [parameter(mandatory=$true)]
        $Title,
        [parameter(mandatory=$true)]
        $ReportDate,
        [parameter(mandatory=$true)]
        $OutputPath
    )
    
    $filename = "$OutputPath\$($ReportDate)_$Title.html"
    
    if ($Global:ADSyncDiagsHtmlReport -ne $null)  
    {
        $Global:ADSyncDiagsHtmlReport += "</body></html>"        
        try 
        {
            $Global:ADSyncDiagsHtmlReport  | Out-String | Out-File -FilePath $filename -ErrorAction Stop
            $resultMsg = "AAD Connect Diagnostics HTML Report is available at: `n$filename `n" 
            $resultMsg | Write-Host -ForegroundColor Green

            "Opening the html report in Internet Explorer..." | Write-Host -fore White
            Write-Host "`r`n"
	
            try
            {
                #
                # Add 'Microsoft.VisualBasic' namespace into PowerShell session.
                #
                Add-Type -AssemblyName "Microsoft.VisualBasic"
        
                $internetExplorer = New-Object -com internetexplorer.application

                $internetExplorer.navigate2($filename)
                $internetExplorer.visible = $true

                if ($internetExplorer.Busy)
                {
                    Sleep -Seconds 15
                }

                $ieProcess = Get-Process | ? { $_.MainWindowHandle -eq $internetExplorer.HWND }

                #
                # Set focus to Internet Explorer so that it will appear on top of other windows.
                #
                [Microsoft.VisualBasic.Interaction]::AppActivate($ieProcess.Id)
            }
            catch
            {
                Write-Error "Unable to open Internet Explorer : $($_.Exception.Message)"
                Write-Host "`r`n"
            }
        }
        catch   
        {
             $resultMsg = "An error occurred while exporting AADConnect Diagnostics to $filename : $($_.Exception.Message)"
             WriteEventLog($EventIdDiagnosticsReportFail)($EventMsgDiagnosticsReportFail -f $resultMsg)
             Write-Error $resultMsg
        }
    }

    return $resultMsg
}

Function Compress-ADSyncDiagnostics
{
    param
    (
        [parameter(mandatory=$true)]
        $Title,
        [parameter(mandatory=$true)]
        $ReportDate,
        [parameter(mandatory=$true)]
        $SourcePath,
        [parameter(mandatory=$true)]
        $OutputPath
    )
    $filename = [string] "$OutputPath\$ReportDate" + "_ADSyncDiagnosticsReport.zip"
    $tempFolder = [string] "$env:temp\$ReportDate" + "_ADSyncDiagnosticsReport"

    # Copy all logs to %Temp% because current 'C:\ProgramData\AADConnect\trace-yyyymmdd-hhmmss.log' is being used by another process
    try  
    {
        Copy-Item $SourcePath $tempFolder -Recurse -ErrorAction Stop
    }
    catch   
    {
        $resultMsg = "Unable to compress AAD Connect Diagnostics information to $filename : $($_.Exception.Message)"
        WriteEventLog($EventIdDiagnosticsReportFail)($EventMsgDiagnosticsReportFail -f $resultMsg)
        Write-Error $resultMsg
        return $resultMsg
    }    

    # Compress AAD Connect Diagnostics folder
    try  
    {
        Add-Type -AssemblyName "System.io.Compression.Filesystem"
        [io.Compression.Zipfile]::CreateFromDirectory($tempFolder, $filename)
        
        $resultMsg = "AADConnect Diagnostics compressed data is available at: `n$filename `n" 
        $resultMsg | Write-Host -ForegroundColor Green
    }
    catch   
    {
        $resultMsg = "Unable to compress AAD Connect Diagnostics information to $filename : $($_.Exception.Message)"
        WriteEventLog($EventIdDiagnosticsReportFail)($EventMsgDiagnosticsReportFail -f $resultMsg)
        Write-Error $resultMsg
    }
    Remove-Item -Path $tempFolder -Recurse -Force
    return $resultMsg
}



#-------------------------------------------------------------------------
#
# Generates a report of AAD Connect Diagnostics including:
#   1- AAD Company Features / Tenant Configuration
#   2- AADConnect Global Settings
#   3- Per Connector Password Hash Sync Status
#   4- Sync Scheduler Settings and Latest Run
#
#-------------------------------------------------------------------------
Function Export-ADSyncDiagnosticsReport 
{
    param
    (
        [parameter(mandatory=$true)]
        $OutputPath 
    )

    $culture = New-Object System.Globalization.CultureInfo 'en-us'
    $reportDate = $(Get-Date -Format yyyyMMdd-HHmmss).ToString($culture)
    $reportFolder = [string] $reportDate + "_ADSyncDiagnosticsReport"
    
    if (-not (Initialize-ADSyncDiagnosticsPath $OutputPath))
    {
        return
    }

    if (-not (Initialize-ADSyncDiagnosticsPath $("$OutputPath\$reportFolder")))
    {
        return
    }

    WriteEventLog($EventIdDiagnosticsReportRun)($EventMsgDiagnosticsReportRun)
    Write-Host "Collecting AAD Connect Diagnostics Information..."
    Write-Host "`r`n"

    Initialize-ADSyncDiagnosticsText
    Initialize-ADSyncDiagnosticsHtml

    # Get Connectors
    $connectors     = Get-ADSyncConnector
    $aadConnectors  = $connectors | Where-Object {$_.SubType -eq "Windows Azure Active Directory (Microsoft)"}
    $adConnectors   = $connectors | Where-Object {$_.ConnectorTypeName -eq "AD"}

    if ($aadConnectors -ne $null -and $adConnectors -ne $null)
    {
        if ($aadConnectors.Count -eq 1)
        {
            # AAD Company Features / Tenant Configuration
            $aadFeatures = Get-ADSyncAADCompanyFeature
            $aadFeaturesPasswordHashSync = $aadFeatures.PasswordHashSync
            Add-ADSyncDiagnosticsText -Title "Azure AD Tenant - Settings" -AppendObject $($aadFeatures | fl)
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Tenant - Settings" -AppendObject $aadFeatures -Format List

            # AADConnect Global Settings
            $globalSettings = Get-ADSyncGlobalSettingsParameter | Select Name,Value | Sort Name
            $globalSettingsPasswordHashSync = [bool] ($globalSettings | Where-Object {$_.Name -eq "Microsoft.OptionalFeature.PasswordHashSync"}).Value
            
            $globalSettings | % { $globalSettingsHt = [ordered]@{} } { $globalSettingsHt[$_.Name] = $_.Value } # Convert to Hashtable
            $globalSettingsObj =  New-Object PSObject -Property $($globalSettingsHt) # Convert to PSObject
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Global Settings" -AppendObject $($globalSettingsObj | fl)
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Global Settings" -AppendObject $globalSettingsObj -Format List

            # Sync Scheduler Settings
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect Sync Scheduler - Settings"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect Sync Scheduler - Settings"

            $syncSchedulerConfig = Get-ADSyncScheduler
            Add-ADSyncDiagnosticsText -AppendObject $($syncSchedulerConfig | fl)
            Add-ADSyncDiagnosticsHtml -AppendObject $syncSchedulerConfig -Format List

            # Sync Scheduler Last Run
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect Sync Scheduler - Last Run"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect Sync Scheduler - Last Run"

            $syncSchedulerLastRunObj = New-Object PSObject -Property @{
                TimeGenerated   = "N/A"
                MachineName     = "N/A"
                EventID         = "N/A"
                EntryType       = "N/A"
                Source          = "N/A"
                Message         = "N/A"
            }

            $syncSchedulerEvents = Get-EventLog -LogName Application -Source "Directory Synchronization" -InstanceId 904 -After (Get-Date).AddHours(-3) -ErrorAction SilentlyContinue |
                                   where  {$_.Message -like "Scheduler::SchedulerThreadMain : Started*"} |
                                   select TimeGenerated, MachineName, EventID, EntryType, Source, Message -First 1

            if ($syncSchedulerEvents -ne $null)
            {
                $syncSchedulerLastRunObj = $syncSchedulerEvents
            }
            Add-ADSyncDiagnosticsText -AppendObject $($syncSchedulerLastRunObj | fl)
            Add-ADSyncDiagnosticsHtml -AppendObject $syncSchedulerLastRunObj -Format List


            # AAD Connect Connectors List
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Connectors"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Connectors"
            $aadcConnectors = $connectors | Select Name,Type,Identifier,Version,CreationTime,LastModificationTime
            Add-ADSyncDiagnosticsText -AppendObject $($aadcConnectors | fl)
            Add-ADSyncDiagnosticsHtml -AppendObject $aadcConnectors -Format List

            # Azure AD Connect - Connector Statistics
            if (Get-Command Get-ADSyncConnectorStatistics -ErrorAction SilentlyContinue)  
            {
                Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Connector Statistics"
                Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Connector Statistics"
            
                # Get Connector Statistics using cmdlet Get-ADSyncConnectorStatistics
                $connectors | %{
                    $connectorStats = Get-ADSyncConnectorStatistics -ConnectorName $_.Name | select *
                    Add-ADSyncDiagnosticsText -AppendObject $($_.Name)
                    Add-ADSyncDiagnosticsText -AppendObject $($connectorStats | fl)
                    Add-ADSyncDiagnosticsHtml -Title $($_.Name) -HeadingSize "H3" -AppendObject $connectorStats -Format List 
                }
            }

            # AAD Connectivity Parameters
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect - AAD Connector Account"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - AAD Connector Account"
            $aadConnectivity = $aadConnectors.ConnectivityParameters | Where-Object {$_.Name -like "UserName"}
            $aadConnectivityStr = "Azure AD Synchronization Service Account: $($aadConnectivity.Value)"        
            Add-ADSyncDiagnosticsText -AppendObject $aadConnectivityStr
            Add-ADSyncDiagnosticsHtml -AppendObject $aadConnectivityStr -Format String

            # AD Connectivity Parameters
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect - AD Connector Account(s)"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - AD Connector Account(s)"
            $adConnectivity = $ADConnectors.ConnectivityParameters | Where-Object {$_.Name -like "forest-login*" -or $_.Name -eq "forest-name"} | select Name,Value
            Add-ADSyncDiagnosticsText -AppendObject $adConnectivity
            Add-ADSyncDiagnosticsHtml -AppendObject $adConnectivity -Format Table

            # AAD Connect Service 
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect - ADSync Service"
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - ADSync Service"
            $adSyncService = Get-WmiObject win32_service | Where-Object {$_.Name -eq 'ADSync'} | Select DisplayName,Name,ProcessId,StartName,StartMode,State,Status,SystemName,PathName
            Add-ADSyncDiagnosticsText -AppendObject $($adSyncService | fl)
            Add-ADSyncDiagnosticsHtml -AppendObject $adSyncService -Format List
            
            # Password Hash Sync Status - Per AD Connector
            Add-ADSyncDiagnosticsText -Title "AD Connector Password Hash Sync - Status"
            Add-ADSyncDiagnosticsHtml -Title "AD Connector Password Hash Sync - Status"
            foreach ($adConnector in $adConnectors)
            {
                $adPasswordSyncConfig = Get-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector.Name

                # Password Hash Sync Heartbeat Check (Ping Event)
                $pingEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 654 -After (Get-Date).AddHours(-3) -ErrorAction SilentlyContinue | 
                              Where-Object { $_.Message.ToUpperInvariant().Contains($adConnector.Identifier.ToString("D").ToUpperInvariant()) } | 
                              Sort-Object  { $_.TimeWritten } -Descending

                $lastHeartbeatTime = $null

                if ($pingEvents -ne $null)
                {
                    $lastHeartbeatTime = $($pingEvents[0].TimeGenerated)
                }
                else
                {
                    $lastHeartbeatTime = "N/A"
                }

                $pwdSyncStateObj = New-Object PSObject -Property @{
                    SourceConnector     = $($adPasswordSyncConfig.SourceConnector)
                    TargetConnector     = $($adPasswordSyncConfig.TargetConnector)
                    Enabled             = $($adPasswordSyncConfig.Enabled)
                    LatestHeartBeatTime = $lastHeartbeatTime
                } | select SourceConnector, TargetConnector, Enabled, LatestHeartBeatTime

                Add-ADSyncDiagnosticsText -AppendObject $($pwdSyncStateObj | fl)
                Add-ADSyncDiagnosticsHtml -AppendObject $pwdSyncStateObj -Format List
            }


            # Azure AD Connect Password Writeback - Status
            $aadPasswordResetConfig = Get-ADSyncAADPasswordResetConfiguration -Connector $aadConnectors[0].Name
            Add-ADSyncDiagnosticsText -Title "Azure AD Connect Password Writeback - Status" -AppendObject $($pwdSyncStateObj | fl)
            Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect Password Writeback - Status" -AppendObject $pwdSyncStateObj -Format List
        }
        else
        {
            Write-Warning "More than one Azure AD connectors are found."
            return
        }

        # Azure AD Connect - Local Database Parameters
        $adSyncParameters = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ADSync\Parameters | 
            Select Server,SQLInstance,DBName,Path
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Local Database Parameters" -AppendObject $($adSyncParameters | fl)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Local Database Parameters" -AppendObject $adSyncParameters -Format List 
            
        if($adSyncParameters.Server -eq "(localdb)")
        {
            # Azure AD Connect - Local Database size

            $pathToDB = "$($adSyncParameters.Path)Data"
            
            if ($adSyncParameters.SQLInstance -ne ".\ADSync")
            {
                $sharedInstanceName = "$($adSyncParameters.SQLInstance.SubString(2))"
                $pathToDB = "$pathToDB\$sharedInstanceName"
            }

            if (Test-Path $pathToDB)   
            {
                $adSyncDatabaseSize = 0
                $adSyncDatabase = Get-ChildItem -Path $pathToDB 

                $adSyncDatabaseSize = ($adSyncDatabase | where Name -eq "ADSync.mdf").Length/1MB
                Add-ADSyncDiagnosticsText -AppendObject "Database size: $("{0:N2}" -f $adSyncDatabaseSize)MB"
                Add-ADSyncDiagnosticsHtml -AppendObject "Database size: $("{0:N2}" -f $adSyncDatabaseSize)MB" -Format String

                if ($adSyncDatabaseSize -gt 7168)  
                {
                    $adSyncDatabasWarning = "WARNING: AAD Connect Database is reaching maximum limit size (10GB) | ADSync.mdf =  $("{0:N2}" -f $adSyncDatabaseSize)MB `n"
                    Add-ADSyncDiagnosticsText -Title $adSyncDatabasWarning
                    Add-ADSyncDiagnosticsHtml -Title $adSyncDatabasWarning -HeadingSize "b"
                }      
            }
            else  
            {
                $adSyncDatabaseError = @("ERROR: Could not find Local Database folder.")
                Add-ADSyncDiagnosticsText -Title $adSyncDatabaseError
                Add-ADSyncDiagnosticsHtml -Title $adSyncDatabaseError -HeadingSize "b"
            }
          
        }

        # Azure AD Connect - Windows Server Configuration      
        $adSyncOS = Get-ADSyncDiagsServerOS
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Windows Server Configuration" -AppendObject $($adSyncOS | fl)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Windows Server Configuration" -AppendObject $adSyncOS -Format List 
    
        # Azure AD Connect - Proxy Settings
        $adSyncSrvProxyIE = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Proxy Settings" -AppendObject ($adSyncSrvProxyIE |fl)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Proxy Settings" -AppendObject $adSyncSrvProxyIE -Format List 
        
        # Azure AD Connect - Netsh Winhttp Settings
        $adSyncSrvNetsh = netsh winhttp show proxy | Out-String
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Netsh Winhttp Settings" -AppendObject ($adSyncSrvNetsh)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Netsh Winhttp Settings" -AppendObject $adSyncSrvNetsh -Format String

        # Azure AD Connect - .Net Framework Installed
        $adSyncSrvDotNet = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" |
            Select-Object -Property Release,Version,InstallPath,TargetVersion
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - .Net Framework Installed" -AppendObject ($adSyncSrvDotNet |fl)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - .Net Framework Installed" -AppendObject $adSyncSrvDotNet -Format List 

        # Azure AD Connect - Current User WhoAmI
        $adSyncSrvWhoAmI = whoami /all
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Current User WhoAmI" -AppendObject $adSyncSrvWhoAmI
        
        # Azure AD Connect - Programs Installed
        $adSyncSrvApplications = Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -Property `
            @{Label="Name"; Expression={if ($_.DisplayName -like "") {$_.PSChildName} else {$_.DisplayName}}}, `
            DisplayVersion, Publisher, `
            @{Label="InstallDate"; Expression={
                if ($_.InstallDate -like "") {$_.InstallDate} else {$date = [int] $_.InstallDate; $date.ToString("0000-00-00")}
            }} | sort Name
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Programs Installed" -AppendObject ($adSyncSrvApplications | ft -AutoSize)
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Programs Installed" -AppendObject $adSyncSrvApplications -Format Table 
        
        # Azure AD Connect - Windows Updates
        $adSyncHotfixes = Get-Hotfix | Select HotFixID,InstalledOn,Description,InstalledBy  | Sort-Object –Descending –Property InstalledOn 
        Add-ADSyncDiagnosticsText -Title "Azure AD Connect - Windows Updates" -AppendObject $adSyncHotfixes
        Add-ADSyncDiagnosticsHtml -Title "Azure AD Connect - Windows Updates" -AppendObject $adSyncHotfixes -Format Table 

        # Export Azure AD Connect - Current User WhoAmI
        $adSyncSrvWhoAmI | Out-File $([string] "$OutputPath\$reportFolder\$reportDate" + "_AADConnect-WhoAmI.txt")

        # Export AAD Connect Full Configuration - Useful when used with AADConnectConfigDocumenter
        Get-ADSyncServerConfiguration -Path $([string] "$OutputPath\$reportFolder\$reportDate" + "_AADConnect-ServerConfig")

        # Azure AD Connect - Export Windows Event Logs
        $after = (Get-Date).AddDays(-7).ToString("yyyy-MM-d")
        $query = "/q:*[System[TimeCreated[@SystemTime>='$($after)T00:00:00.000Z']]]"
        $filename = [string] "$OutputPath\$reportFolder\$reportDate" + "_AADConnect-EvtLogsApplication.evtx"
        wevtutil epl Application $filename $query "/ow:true"
        $filename = [string] "$OutputPath\$reportFolder\$reportDate" + "_AADConnect-EvtLogsSystem.evtx"
        wevtutil epl System $filename $query "/ow:true"

        # Phase 1/2 - Exporting AAD Connect Diagnostics Information
        Write-Host "Exporting AAD Connect Diagnostics Information..."
        Write-Host "`r`n"

        $resultTextReport = Export-ADSyncDiagnosticsText -Title "AADConnect_Report" -ReportDate $reportDate -OutputPath $OutputPath
        $resultHtmlReport = Export-ADSyncDiagnosticsHtml -Title "AADConnect_Report" -ReportDate $reportDate -OutputPath $("$OutputPath\$reportFolder")

        # Phase 2/2 - Compress AAD Connect Diagnostics Information
        if ($OutputPath -eq $("$env:ALLUSERSPROFILE\AADConnect"))
        {
            # Compress all information in ProgramData\AADConnect
            Write-Host "Compressing AAD Connect Diagnostics Information..."
            $resultCompressData = Compress-ADSyncDiagnostics -Title "AADConnect_Report" -ReportDate $reportDate -SourcePath $("$env:ALLUSERSPROFILE\AADConnect") -OutputPath "$env:USERPROFILE\Documents"
        }

        $EventMsgDiagnosticsReportResults = [string] $resultTextReport + "`r`n" + $resultHtmlReport + "`r`n" + $resultCompressData
        WriteEventLog($EventIdDiagnosticsReportEnd)($EventMsgDiagnosticsReportEnd -f $EventMsgDiagnosticsReportResults)
        return
    }

    if ($aadConnectors -eq $null)
    {
        Write-Warning "No AAD connectors are found."
    }

    if ($adConnectors -eq $null)
    {
        Write-Warning "No AD connectors are found."
    }
}

# SIG # Begin signature block
# MIIoNgYJKoZIhvcNAQcCoIIoJzCCKCMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBNI02sr/uI24jl
# xzSTwxzZufaex0zsnej98aIK/8eWSaCCDYIwggYAMIID6KADAgECAhMzAAADXJXz
# SFtKBGrPAAAAAANcMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwNDA2MTgyOTIyWhcNMjQwNDAyMTgyOTIyWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDijA1UCC84R0x+9Vr/vQhPNbfvIOBFfymE+kuP+nho3ixnjyv6vdnUpgmm6RT/
# pL9cXL27zmgVMw7ivmLjR5dIm6qlovdrc5QRrkewnuQHnvhVnLm+pLyIiWp6Tow3
# ZrkoiVdip47m+pOBYlw/vrkb8Pju4XdA48U8okWmqTId2CbZTd8yZbwdHb8lPviE
# NMKzQ2bAjytWVEp3y74xc8E4P6hdBRynKGF6vvS6sGB9tBrvu4n9mn7M99rp//7k
# ku5t/q3bbMjg/6L6mDePok6Ipb22+9Fzpq5sy+CkJmvCNGPo9U8fA152JPrt14uJ
# ffVvbY5i9jrGQTfV+UAQ8ncPAgMBAAGjggF/MIIBezArBgNVHSUEJDAiBgorBgEE
# AYI3TBMBBgorBgEEAYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUXgIsrR+tkOQ8
# 10ekOnvvfQDgTHAwRQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEWMBQGA1UEBRMNMjMzMTEwKzUwMDg2ODAfBgNVHSMEGDAWgBRI
# bmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEt
# MDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBABIm
# T2UTYlls5t6i5kWaqI7sEfIKgNquF8Ex9yMEz+QMmc2FjaIF/HQQdpJZaEtDM1Xm
# 07VD4JvNJEplZ91A4SIxjHzqgLegfkyc384P7Nn+SJL3XK2FK+VAFxdvZNXcrkt2
# WoAtKo0PclJOmHheHImWSqfCxRispYkKT9w7J/84fidQxSj83NPqoCfUmcy3bWKY
# jRZ6PPDXlXERRvl825dXOfmCKGYJXHKyOEcU8/6djs7TDyK0eH9ss4G9mjPnVZzq
# Gi/qxxtbddZtkREDd0Acdj947/BTwsYLuQPz7SNNUAmlZOvWALPU7OOVQlEZzO8u
# Ec+QH24nep/yhKvFYp4sHtxUKm1ZPV4xdArhzxJGo48Be74kxL7q2AlTyValLV98
# u3FY07rNo4Xg9PMHC6sEAb0tSplojOHFtGtNb0r+sioSttvd8IyaMSfCPwhUxp+B
# Td0exzQ1KnRSBOZpxZ8h0HmOlMJOInwFqrCvn5IjrSdjxKa/PzOTFPIYAfMZ4hJn
# uKu15EUuv/f0Tmgrlfw+cC0HCz/5WnpWiFso2IPHZyfdbbOXO2EZ9gzB1wmNkbBz
# hj8hFyImnycY+94Eo2GLavVTtgBiCcG1ILyQabKDbL7Vh/OearAxcRAmcuVAha07
# WiQx2aLghOSaZzKFOx44LmwUxRuaJ4vO/PRZ7EzAMIIHejCCBWKgAwIBAgIKYQ6Q
# 0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5
# WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQD
# Ex9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4
# BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe
# 0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato
# 88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v
# ++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDst
# rjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN
# 91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4ji
# JV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmh
# D+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbi
# wZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8Hh
# hUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaI
# jAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTl
# UAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNV
# HQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQF
# TuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcC
# ARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnlj
# cHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5
# AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oal
# mOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0ep
# o/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1
# HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtY
# SWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInW
# H8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZ
# iWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMd
# YzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7f
# QccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKf
# enoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOpp
# O6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZO
# SEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4xCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jv
# c29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANclfNIW0oEas8AAAAAA1ww
# DQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEDzpfMi
# DJtzD5PeF1z75mfCHUgQcOu6FzvqKJj79UpzMEIGCisGAQQBgjcCAQwxNDAyoBSA
# EgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20w
# DQYJKoZIhvcNAQEBBQAEggEA0eI3uNrPLbp9i7xYxvkpWvucxRPW4DcJAHunMUQC
# pbHHu+7K9aUM/WW1TMTOT+zGgiGpXyV7BGhKa/cFDImxZMpmqOnInCWQc1i15+SE
# SKwbXZQu5+lcroF5PLLD5WNcW4YZ2q95LaFGuHcqh3RQUKwQ1ocxcMDYUJNb5R9a
# HkdiRA+dmjByFfsyay1oaz5XZKP2tjn8OZEPaiTDcJT+eaSdY1ZoWaLNorcshgyD
# wOste7cFRgJdruWF2p7e2NwNtRS6Xgo6CY5qPJhvDBoAmLDRxaWfBb0l8Qh1MfOK
# dDOOHIZTXwCfP3o9mskx1gEOdX/NQxHtZDuM5UapmvZ8DKGCF5QwgheQBgorBgEE
# AYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZIAWUD
# BAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoD
# ATAxMA0GCWCGSAFlAwQCAQUABCDWxe6nEGTaiXItzrZC0DSkrs0p3Ub39bMMfx6o
# LpGpmwIGZQPvahiuGBMyMDIzMTAwNDE5Mjg1NS41MjRaMASAAgH0oIHRpIHOMIHL
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxN
# aWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRT
# UyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFNlcnZpY2WgghHqMIIHIDCCBQigAwIBAgITMwAAAdB3CKrvoxfG3QABAAAB
# 0DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAe
# Fw0yMzA1MjUxOTEyMTRaFw0yNDAyMDExOTEyMTRaMIHLMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmlj
# YSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0wNUUw
# LUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDfMlfn35fvM0XAUSmI5qiG0UxP
# i25HkSyBgzk3zpYO311d1OEEFz0QpAK23s1dJFrjB5gD+SMw5z6EwxC4CrXU9KaQ
# 4WNHqHrhWftpgo3MkJex9frmO9MldUfjUG56sIW6YVF6YjX+9rT1JDdCDHbo5nZi
# asMigGKawGb2HqD7/kjRR67RvVh7Q4natAVu46Zf5MLviR0xN5cNG20xwBwgttaY
# Ek5XlULaBH5OnXz2eWoIx+SjDO7Bt5BuABWY8SvmRQfByT2cppEzTjt/fs0xp4B1
# cAHVDwlGwZuv9Rfc3nddxgFrKA8MWHbJF0+aWUUYIBR8Fy2guFVHoHeOze7Isbyv
# Rrax//83gYqo8c5Z/1/u7kjLcTgipiyZ8XERsLEECJ5ox1BBLY6AjmbgAzDdNl2L
# eej+qIbdBr/SUvKEC+Xw4xjFMOTUVWKWemt2khwndUfBNR7Nzu1z9L0Wv7TAY/v+
# v6pNhAeohPMCFJc+ak6uMD8TKSzWFjw5aADkmD9mGuC86yvSKkII4MayzoUdseT0
# nfk8Y0fPjtdw2Wnejl6zLHuYXwcDau2O1DMuoiedNVjTF37UEmYT+oxC/OFXUGPD
# EQt9tzgbR9g8HLtUfEeWOsOED5xgb5rwyfvIss7H/cdHFcIiIczzQgYnsLyEGepo
# ZDkKhSMR5eCB6Kcv/QIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDPhAYWS0oA+lOtI
# TfjJtyl0knRRMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1Ud
# HwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3Js
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggr
# BgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIw
# MTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgw
# DgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCXh+ckCkZaA06SNW+q
# xtS9gHQp4x7G+gdikngKItEr8otkXIrmWPYrarRWBlY91lqGiilHyIlZ3iNBUbaN
# EmaKAGMZ5YcS7IZUKPaq1jU0msyl+8og0t9C/Z26+atx3vshHrFQuSgwTHZVpzv7
# k8CYnBYoxdhI1uGhqH595mqLvtMsxEN/1so7U+b3U6LCry5uwwcz5+j8Oj0GUX3b
# +iZg+As0xTN6T0Qa8BNec/LwcyqYNEaMkW2VAKrmhvWH8OCDTcXgONnnABQHBfXK
# /fLAbHFGS1XNOtr62/iaHBGAkrCGl6Bi8Pfws6fs+w+sE9r3hX9Vg0gsRMoHRuMa
# iXsrGmGsuYnLn3AwTguMatw9R8U5vJtWSlu1CFO5P0LEvQQiMZ12sQSsQAkNDTs9
# rTjVNjjIUgoZ6XPMxlcPIDcjxw8bfeb4y4wAxM2RRoWcxpkx+6IIf2L+b7gLHtBx
# XCWJ5bMW7WwUC2LltburUwBv0SgjpDtbEqw/uDgWBerCT+Zty3Nc967iGaQjyYQH
# 6H/h9Xc8smm2n6VjySRx2swnW3hr6Qx63U/xY9HL6FNhrGiFED7ZRKrnwvvXvMVQ
# UIEkB7GUEeN6heY8gHLt0jLV3yzDiQA8R8p5YGgGAVt9MEwgAJNY1iHvH/8vzhJS
# ZFNkH8svRztO/i3TvKrjb8ZxwjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkA
# AAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRl
# IEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVow
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX
# 9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1q
# UoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8d
# q6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byN
# pOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2k
# rnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4d
# Pf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgS
# Uei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8
# QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6Cm
# gyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzF
# ER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQID
# AQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQU
# KqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1
# GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0
# dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0
# bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMA
# QTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbL
# j+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1p
# Y3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0w
# Ni0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIz
# LmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwU
# tj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN
# 3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU
# 5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5
# KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGy
# qVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB6
# 2FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltE
# AY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFp
# AUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcd
# FYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRb
# atGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQd
# VTNYs6FwZvKhggNNMIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVFMC1E
# OTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEw
# BwYFKw4DAhoDFQC8t8hT8KKUX91lU5FqRP9Cfu9MiaCBgzCBgKR+MHwxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
# dCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6Mgg9zAiGA8y
# MDIzMTAwNDE3MzU1MVoYDzIwMjMxMDA1MTczNTUxWjB0MDoGCisGAQQBhFkKBAEx
# LDAqMAoCBQDoyCD3AgEAMAcCAQACAi61MAcCAQACAhKsMAoCBQDoyXJ3AgEAMDYG
# CisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEA
# AgMBhqAwDQYJKoZIhvcNAQELBQADggEBADlTQbPDOOm5HC5mXCXkzvC2DduTvP1h
# hrt3O23qFekm0w0RrHZwv3Jbvuk0buL9eIle/qW+I9RZ/nPa0Y+ouAmcn0fo54w4
# vyFL/V1UQA6kQToxFXpDIdwxvRl0PTuyPxvDIwv50sAmitrSQJLZdor6/1vIDimq
# evkBpG/wsCS7Mx89lC+ITrN4y7voqBvpCIQ7N7nnJZkxP3CgAykN+Pfl7QKXPLQ7
# sCVZDluHuM1zVlOTpxCGbEBKI0sjuaOzIyFsj+u9mTIINf2n7F342urEEvP+V9Av
# EHUuCHpDooyPx68z+9G3OZTPvdMAtHKMQT99Fq6YL/NV49rGeSQ1UF0xggQNMIIE
# CQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYw
# JAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdB3CKrv
# oxfG3QABAAAB0DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqG
# SIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCBdwBf9HmsHL4MGlEbdtRPEhvgoUlCC
# VKsnNDPdQ1F7UjCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIAiVQAZftNP/
# Md1E2Yw+fBXa9w6fjmTZ5WAerrTSPwnXMIGYMIGApH4wfDELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgUENBIDIwMTACEzMAAAHQdwiq76MXxt0AAQAAAdAwIgQgETTCKldTZFdc
# jF2QkzW7ezxv1zZ1TLLH6rBwCeGd6aQwDQYJKoZIhvcNAQELBQAEggIAaC8kshHt
# BJUKZb93va3vFIjbSS6fSMQxR0xaz1zpkFtc1/EaR5W/9/k8TV4P8ZZcZ/y6guEW
# U3fBj2De/arpjoPp6qeapQaRCa+XzFJ4w0gkmRAyxKFdM+/hyFZ9gN7wF4qzqAwW
# NUGgfhsr39R6xLaA5NyUsUq8muY10blk+vQR66IHMTJdPNTsM/osSMySNGYpwAER
# xOaHXB3Cfsr9oAeIKrRpa0oAPf0R6qtqcrduOYjapA2rZ/4LqERppjSuOAGbDjpx
# 6Spha93NV6NC6ShTMMReVc5dg60C3+SRSQzE/bA0DN5BErr+MymCtwkKdVJl3Pj7
# RC0tnxcd2FLo6eJT0OnLyhxQW2nc3gjjXbh0vRxq7WQd03qLVFDNkhS0pXO9EQ2n
# x+86cf+TIA67Br8t4WUbJcqIcNaTiNiOjvWt+U84nIIWtEZ+qigbwh1iYuzVopyN
# 8IMaypYZdLpXVe3ATuK/O/TGZhnCszvxGhkBNq4mrWOgWudNUzspcFDcss6U/sSN
# pefCvNLxHb1lmFUWfDVNArDFQPysGUdr6aeQgyDWKnJHRh3ZI+Pwhsd4vmiIIOEk
# BTH2/GK56YJjtyGIV3JxeEPePMExH2HiZ/n0hWOA6ho1s5DPHIb5BvlMZh+N8XrI
# weZ7f5llisE6BC+KcCOmc6LuEexCAEy7Xuc=
# SIG # End signature block
