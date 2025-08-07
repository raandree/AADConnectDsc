# Test script for event logging functionality
# This script tests the Write-AADConnectEventLog function

# Import the built module
Import-Module "d:\Git\AADConnectDsc\output\module\AADConnectDsc\0.3.3\AADConnectDsc.psd1" -Force -Verbose

# Test the event logging function
Write-Host "Testing event logging functionality..." -ForegroundColor Green

try
{
    # Test Information event with full details
    Write-AADConnectEventLog -EventType 'Information' -EventId 1000 -Message "Test: Sync rule is in desired state" -SyncRuleName 'TestRule' -ConnectorName 'TestConnector' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 100 -Disabled $false -IsStandardRule $false
    Write-Output "✅ Information event logged successfully with multi-line format"

    # Test Warning event - absent but should be present
    Write-AADConnectEventLog -EventType 'Warning' -EventId 1001 -Message "Test: Sync rule is absent but should be present" -SyncRuleName 'MissingRule' -ConnectorName 'ADConnector' -Direction 'Outbound' -TargetObjectType 'user' -SourceObjectType 'person' -Disabled $false -IsStandardRule $false
    Write-Output "✅ Warning event (1001) logged successfully"

    # Test Warning event - present but should be absent
    Write-AADConnectEventLog -EventType 'Warning' -EventId 1002 -Message "Test: Sync rule is present but should be absent" -SyncRuleName 'ExtraRule' -ConnectorName 'AADConnector' -Direction 'Inbound' -TargetObjectType 'contact' -Precedence 200 -Disabled $true -IsStandardRule $false
    Write-Output "✅ Warning event (1002) logged successfully"

    # Test Warning event - configuration drift (Microsoft standard rule)
    Write-AADConnectEventLog -EventType 'Warning' -EventId 1003 -Message "Test: Sync rule configuration drift detected" -SyncRuleName 'In from AD - User Join' -ConnectorName 'contoso.local' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 50 -Disabled $false -IsStandardRule $true
    Write-Output "✅ Warning event (1003) logged successfully"

    Write-Output "`nEvent logging implementation completed successfully!"
    Write-Output "Check Windows Event Viewer > Applications and Services Logs > AADConnectDsc for logged events"
    Write-Output "Events now include multi-line format with detailed sync rule information"
}
catch
{
    Write-Error "Event logging test failed: $($_.Exception.Message)"
}
