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

    # Test Information event - sync rule created
    Write-AADConnectEventLog -EventType 'Information' -EventId 2000 -Message "Test: Sync rule created successfully" -SyncRuleName 'New Custom Rule' -ConnectorName 'contoso.local' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 120 -Disabled $false -IsStandardRule $false -Operation 'Create' -RuleIdentifier '{12345678-1234-1234-1234-123456789abc}' -ScopeFilterCount 2 -JoinFilterCount 1 -AttributeFlowMappingCount 5
    Write-Output "✅ Information event (2000 - Create) logged successfully"

    # Test Information event - sync rule updated
    Write-AADConnectEventLog -EventType 'Information' -EventId 2001 -Message "Test: Sync rule updated successfully" -SyncRuleName 'Updated Custom Rule' -ConnectorName 'tenant.onmicrosoft.com - AAD' -Direction 'Outbound' -TargetObjectType 'user' -SourceObjectType 'person' -Precedence 130 -Disabled $false -IsStandardRule $false -Operation 'Update' -RuleIdentifier '{87654321-4321-4321-4321-abcdef123456}' -ScopeFilterCount 1 -JoinFilterCount 1 -AttributeFlowMappingCount 3
    Write-Output "✅ Information event (2001 - Update) logged successfully"

    # Test Information event - standard rule state change
    Write-AADConnectEventLog -EventType 'Information' -EventId 2002 -Message "Test: Standard sync rule disabled state changed successfully" -SyncRuleName 'In from AD - User Join' -ConnectorName 'contoso.local' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 50 -Disabled $true -IsStandardRule $true -Operation 'Changed Disabled state from False to True' -RuleIdentifier '{abcdef12-3456-7890-abcd-ef1234567890}'
    Write-Output "✅ Information event (2002 - State Change) logged successfully"

    # Test Information event - sync rule removed
    Write-AADConnectEventLog -EventType 'Information' -EventId 2003 -Message "Test: Sync rule removed successfully" -SyncRuleName 'Obsolete Rule' -ConnectorName 'contoso.local' -Direction 'Inbound' -TargetObjectType 'contact' -SourceObjectType 'contact' -Precedence 999 -Disabled $true -IsStandardRule $false -Operation 'Remove' -RuleIdentifier '{fedcba09-8765-4321-fedc-ba0987654321}'
    Write-Output "✅ Information event (2003 - Remove) logged successfully"

    Write-Output "`nEnhanced event logging implementation completed successfully!"
    Write-Output "Check Windows Event Viewer > Applications and Services Logs > AADConnectDsc for logged events"
    Write-Output "Events now include multi-line format with detailed sync rule information"
    Write-Output "New Set() operation events (2000-2003) provide complete audit trail of changes"
}
catch
{
    Write-Error "Event logging test failed: $($_.Exception.Message)"
}
