# Debug test for Set() method event logging
Import-Module ".\output\module\AADConnectDsc" -Force

# Mock the AAD Connect cmdlets for testing
function Get-ADSyncConnector {
    param($Name, $ErrorAction)
    Write-Host "Mock: Get-ADSyncConnector called with Name='$Name'"
    return [PSCustomObject]@{
        Name = $Name
        Identifier = [guid]::NewGuid()
    }
}

function Get-ADSyncRule {
    param($Name, $ConnectorName)
    Write-Host "Mock: Get-ADSyncRule called with Name='$Name', ConnectorName='$ConnectorName'"
    return $null  # Return null to simulate new rule
}

function New-ADSyncRule {
    param(
        $Name, $ConnectorName, $Direction, $TargetObjectType,
        $SourceObjectType, $Precedence, $Disabled, $LinkType
    )

    Write-Host "Mock: New-ADSyncRule called with Name='$Name'"
    return [PSCustomObject]@{
        Name = $Name
        Identifier = [guid]::NewGuid()
        ConnectorName = $ConnectorName
        Direction = $Direction
        TargetObjectType = $TargetObjectType
        SourceObjectType = $SourceObjectType
        Precedence = $Precedence
        Disabled = $Disabled
        LinkType = $LinkType
    }
}

function Add-ADSyncRule {
    param([Parameter(ValueFromPipeline)]$Rule)
    Write-Host "Mock: Add-ADSyncRule called for rule '$($Rule.Name)'"
    return $Rule
}

# Override the Write-AADConnectEventLog function to see if it's being called
function Write-AADConnectEventLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$EventType,
        [Parameter(Mandatory = $true)]
        [int]$EventId,
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [string]$SyncRuleName,
        [string]$ConnectorName,
        [string]$Direction,
        [string]$TargetObjectType,
        [string]$SourceObjectType,
        [int]$Precedence,
        [bool]$Disabled,
        [bool]$IsStandardRule,
        [string]$Operation,
        [int]$ScopeFilterCount,
        [int]$JoinFilterCount,
        [int]$AttributeFlowMappingCount,
        [string]$RuleIdentifier
    )

    Write-Host "🔔 EVENT LOGGED: EventType=$EventType, EventId=$EventId, Message='$Message'"
    Write-Host "   SyncRuleName='$SyncRuleName', ConnectorName='$ConnectorName'"
    Write-Host "   Operation='$Operation', RuleIdentifier='$RuleIdentifier'"
}

Write-Host "Testing Set() method with event logging debugging..."

try {
    # Create a configuration
    Configuration TestSetMethod {
        Import-DscResource -ModuleName AADConnectDsc

        Node localhost {
            AADSyncRule TestRule {
                Name = "Test-SetMethod-Rule"
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

    # Generate the configuration
    $configPath = ".\TestSetMethod"
    if (Test-Path $configPath) {
        Remove-Item $configPath -Recurse -Force
    }

    Write-Host "Generating DSC configuration..."
    TestSetMethod -OutputPath $configPath

    Write-Host "Running DSC configuration (this should call Set() method)..."
    Start-DscConfiguration -Path $configPath -Wait -Verbose -Force

    Write-Host "DSC configuration completed."

} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
}
