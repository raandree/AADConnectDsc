# Direct test of event logging functionality
# Load the source files directly to access private functions

# Load the private function
. ".\source\Private\Write-AADConnectEventLog.ps1"

Write-Host "Testing Write-AADConnectEventLog function directly..."

try {
    # Test creating a new event log entry
    Write-AADConnectEventLog -EventType 'Information' -EventId 2000 -Message "Test sync rule created successfully" -SyncRuleName 'TestRule' -ConnectorName 'TestConnector' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 100 -Disabled $false -IsStandardRule $false -Operation 'Create' -RuleIdentifier 'test-guid-123' -ScopeFilterCount 1 -JoinFilterCount 1 -AttributeFlowMappingCount 3 -Verbose

    Write-Host "Event log entry created successfully!"

    # Check if the event log was created and contains our entry
    if ([System.Diagnostics.EventLog]::Exists("AADConnectDsc")) {
        Write-Host "AADConnectDsc event log found!"

        $events = Get-WinEvent -LogName AADConnectDsc -MaxEvents 5 -ErrorAction SilentlyContinue
        if ($events) {
            Write-Host "Found $($events.Count) recent event(s):"
            $events | ForEach-Object {
                Write-Host ""
                Write-Host "Event ID: $($_.Id)"
                Write-Host "Level: $($_.LevelDisplayName)"
                Write-Host "Time: $($_.TimeCreated)"
                Write-Host "Message:"
                Write-Host $_.Message
                Write-Host "---"
            }
        } else {
            Write-Host "No events found in AADConnectDsc log"
        }
    } else {
        Write-Host "AADConnectDsc event log was not created"
    }

    # Test another event type
    Write-Host "Testing warning event..."
    Write-AADConnectEventLog -EventType 'Warning' -EventId 1001 -Message "Test sync rule is absent but should be present" -SyncRuleName 'TestRule' -ConnectorName 'TestConnector' -Direction 'Inbound' -TargetObjectType 'person' -SourceObjectType 'user' -Precedence 100 -Disabled $false -IsStandardRule $false

    Write-Host "Warning event created successfully!"

} catch {
    Write-Host "Error testing event logging: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
}
