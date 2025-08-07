# Test DSC configuration to verify event logging
Configuration TestAADConnectDsc
{
    Import-DscResource -ModuleName AADConnectDsc

    Node localhost
    {
        AADSyncRule TestRule
        {
            Name = "TestSyncRule"
            ConnectorName = "TestConnector"
            Direction = "Inbound"
            TargetObjectType = "person"
            SourceObjectType = "user"
            Precedence = 100
            Disabled = $false
            Ensure = "Present"
        }
    }
}

# Test the configuration
try {
    Write-Host "Creating DSC configuration..."
    $configData = TestAADConnectDsc -OutputPath ".\TestDSC"
    Write-Host "Configuration created successfully: $configData"

    Write-Host "Testing DSC configuration (this should generate event log entries)..."
    Test-DscConfiguration -Path ".\TestDSC" -Verbose

    Write-Host "Checking for event log entries..."
    if (Get-WinEvent -LogName AADConnectDsc -MaxEvents 5 -ErrorAction SilentlyContinue) {
        Write-Host "Event log entries found!"
        Get-WinEvent -LogName AADConnectDsc -MaxEvents 5 | Format-Table TimeCreated, Id, LevelDisplayName, Message -Wrap
    } else {
        Write-Host "No event log entries found in AADConnectDsc log"
    }

} catch {
    Write-Host "Error in DSC test: $($_.Exception.Message)"
}
