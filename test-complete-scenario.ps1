# Test to check if event logging errors are being silently caught

# Check if Write-AADConnectEventLog is available from the module
Import-Module ".\output\module\AADConnectDsc" -Force

# Test the function directly through the module
try {
    Write-Host "Testing if Write-AADConnectEventLog is available from module..."

    # Try to invoke the function through the module context
    & (Get-Module AADConnectDsc) {
        Write-AADConnectEventLog -EventType 'Information' -EventId 2000 -Message "Test message" -SyncRuleName "TestRule" -Verbose
    }

    Write-Host "Function call succeeded!"

} catch {
    Write-Host "Function call failed: $($_.Exception.Message)"
}

# Now let's test a complete scenario by importing functions needed and mocking AAD Connect cmdlets
Write-Host "`nTesting complete scenario with mocked AAD Connect environment..."

# Mock all the AAD Connect functions
function Get-ADSyncConnector {
    param($Name, $ErrorAction)
    return [PSCustomObject]@{
        Name = $Name
        Identifier = [guid]::NewGuid()
    }
}

function Get-ADSyncRule {
    param($Name, $ConnectorName)
    return $null  # No existing rule = new rule
}

function New-ADSyncRule {
    return [PSCustomObject]@{
        Name = "TestRule"
        Identifier = [guid]::NewGuid()
    }
}

function Add-ADSyncRule {
    param([Parameter(ValueFromPipeline)]$Rule)
    Write-Host "✅ Add-ADSyncRule called successfully for rule: $($Rule.Name)"
}

function Get-Command {
    param($Name)
    if ($Name -eq "New-ADSyncRule") {
        return [PSCustomObject]@{
            Parameters = @{}
        }
    }
    return & "Microsoft.PowerShell.Core\Get-Command" @args
}

function Sync-Parameter {
    param($Command, $Parameters)
    return @{
        Name = $Parameters.Name
        ConnectorName = $Parameters.ConnectorName
        Direction = $Parameters.Direction
        TargetObjectType = $Parameters.TargetObjectType
        SourceObjectType = $Parameters.SourceObjectType
        LinkType = $Parameters.LinkType
        Precedence = $Parameters.Precedence
        Disabled = $Parameters.Disabled
    }
}

function Convert-ObjectToHashtable {
    param($Object)
    return @{
        Name = $Object.Name
        ConnectorName = $Object.ConnectorName
        Direction = $Object.Direction
        TargetObjectType = $Object.TargetObjectType
        SourceObjectType = $Object.SourceObjectType
        LinkType = $Object.LinkType
        Precedence = $Object.Precedence
        Disabled = $Object.Disabled
        Ensure = $Object.Ensure
    }
}

function New-Guid2 {
    param($InputString)
    return [guid]::NewGuid()
}

try {
    # Now let's try using a DSC configuration
    Configuration TestEventLogScenario {
        Import-DscResource -ModuleName AADConnectDsc

        Node localhost {
            AADSyncRule TestEventRule {
                Name = "EventTest-Rule-123"
                ConnectorName = "test.local"
                Direction = "Inbound"
                TargetObjectType = "person"
                SourceObjectType = "user"
                LinkType = "Join"
                Precedence = 150
                Disabled = $false
                Ensure = "Present"
            }
        }
    }

    Write-Host "Creating configuration..."
    $configPath = ".\TestEventLogScenario"
    if (Test-Path $configPath) { Remove-Item $configPath -Recurse -Force }

    # Try to run in Windows PowerShell mode if available
    try {
        TestEventLogScenario -OutputPath $configPath
        Write-Host "✅ Configuration created successfully"

        Write-Host "Running Test-DscConfiguration..."
        Test-DscConfiguration -Path $configPath -Verbose

        Write-Host "Running Start-DscConfiguration..."
        Start-DscConfiguration -Path $configPath -Wait -Verbose -Force

    } catch {
        Write-Host "❌ DSC Configuration failed: $($_.Exception.Message)"
    }

    # Check for events
    Write-Host "`nChecking for events..."
    if ([System.Diagnostics.EventLog]::Exists("AADConnectDsc")) {
        $events = Get-WinEvent -LogName "AADConnectDsc" -MaxEvents 10 -ErrorAction SilentlyContinue
        if ($events) {
            Write-Host "🎉 Found $($events.Count) events:"
            $events | ForEach-Object {
                Write-Host "  Event ID: $($_.Id), Time: $($_.TimeCreated), Message: $($_.Message)"
            }
        } else {
            Write-Host "😐 Event log exists but no events found"
        }
    } else {
        Write-Host "😟 AADConnectDsc event log does not exist"
    }

} catch {
    Write-Host "❌ Test failed: $($_.Exception.Message)"
    Write-Host "Stack: $($_.Exception.StackTrace)"
}
