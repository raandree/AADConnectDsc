# Test AADSyncRule functionality through DSC Configuration
Import-Module ".\output\module\AADConnectDsc" -Force

# Mock the AAD Connect cmdlets for testing
$global:MockConnector = [PSCustomObject]@{
    Name = "TestConnector"
    Identifier = [guid]::NewGuid()
}

$global:MockSyncRule = $null

function Get-ADSyncConnector {
    param($Name, $ErrorAction)
    return $global:MockConnector
}

function Get-ADSyncRule {
    param($Name, $ConnectorName)
    return $global:MockSyncRule  # Return null for new rule
}

function New-ADSyncRule {
    param(
        $Name, $ConnectorName, $Direction, $TargetObjectType,
        $SourceObjectType, $Precedence, $Disabled
    )

    return [PSCustomObject]@{
        Name = $Name
        Identifier = [guid]::NewGuid()
        ConnectorName = $ConnectorName
        Direction = $Direction
        TargetObjectType = $TargetObjectType
        SourceObjectType = $SourceObjectType
        Precedence = $Precedence
        Disabled = $Disabled
    }
}

function Add-ADSyncRule {
    param([Parameter(ValueFromPipeline)]$Rule)
    Write-Host "Mock: Adding sync rule '$($Rule.Name)' with ID '$($Rule.Identifier)'"
    return $Rule
}

# Create DSC Configuration
Configuration TestEventLogging
{
    Import-DscResource -ModuleName AADConnectDsc

    Node localhost
    {
        AADSyncRule TestSyncRule
        {
            Name = "TestEventRule"
            ConnectorName = "TestConnector"
            Direction = "Inbound"
            TargetObjectType = "person"
            SourceObjectType = "user"
            LinkType = "Join"
            Precedence = 100
            Disabled = $false
            Ensure = "Present"
        }
    }
}

try {
    Write-Host "Creating DSC configuration for event logging test..."
    $configPath = ".\TestEventLogging"

    # Clean up previous test
    if (Test-Path $configPath) {
        Remove-Item $configPath -Recurse -Force
    }

    # Generate configuration
    TestEventLogging -OutputPath $configPath

    Write-Host "Testing DSC configuration - this should trigger event logging..."
    Test-DscConfiguration -Path $configPath -Verbose

    Write-Host "Checking for AADConnectDsc event log entries..."

    # Check if the event log exists
    if ([System.Diagnostics.EventLog]::Exists("AADConnectDsc")) {
        Write-Host "AADConnectDsc event log found!"

        $events = Get-WinEvent -LogName AADConnectDsc -MaxEvents 10 -ErrorAction SilentlyContinue
        if ($events) {
            Write-Host "Found $($events.Count) event(s):"
            $events | ForEach-Object {
                Write-Host "Event ID: $($_.Id), Level: $($_.LevelDisplayName), Time: $($_.TimeCreated)"
                Write-Host "Message: $($_.Message)"
                Write-Host "---"
            }
        } else {
            Write-Host "No events found in AADConnectDsc log"
        }
    } else {
        Write-Host "AADConnectDsc event log does not exist yet"
    }

} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Stack: $($_.Exception.StackTrace)"
}
