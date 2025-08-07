# Direct test of Set() method event logging
# Load the module and source files

Import-Module ".\output\module\AADConnectDsc" -Force

# Load the classes directly
. ".\source\Private\Write-AADConnectEventLog.ps1"
. ".\source\Private\New-Guid2.ps1"

# Mock the AAD Connect cmdlets
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

function Get-Command {
    param($Name)
    if ($Name -eq "New-ADSyncRule") {
        return [PSCustomObject]@{
            Parameters = @{
                Name = @{ ParameterType = [string] }
                ConnectorName = @{ ParameterType = [string] }
                Direction = @{ ParameterType = [string] }
                TargetObjectType = @{ ParameterType = [string] }
                SourceObjectType = @{ ParameterType = [string] }
                Precedence = @{ ParameterType = [int] }
                Disabled = @{ ParameterType = [bool] }
                LinkType = @{ ParameterType = [string] }
            }
        }
    }
    return & "Get-Command" @args
}

function Sync-Parameter {
    param($Command, $Parameters)
    return $Parameters
}

# Override Write-AADConnectEventLog to monitor calls
$global:EventLogCalls = @()
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

    $eventCall = @{
        EventType = $EventType
        EventId = $EventId
        Message = $Message
        SyncRuleName = $SyncRuleName
        ConnectorName = $ConnectorName
        Operation = $Operation
        RuleIdentifier = $RuleIdentifier
    }

    $global:EventLogCalls += $eventCall
    Write-Host "🔔 EVENT LOGGED: EventType=$EventType, EventId=$EventId, Message='$Message'"
    Write-Host "   SyncRuleName='$SyncRuleName', ConnectorName='$ConnectorName'"
    Write-Host "   Operation='$Operation', RuleIdentifier='$RuleIdentifier'"
}

Write-Host "Testing Set() method directly..."

try {
    # Load the AADSyncRule class
    . ".\source\Classes\AADSyncRule.ps1"

    # Create an instance
    $syncRule = [AADSyncRule]::new()
    $syncRule.Name = "Test-SetMethod-Rule"
    $syncRule.ConnectorName = "TestConnector"
    $syncRule.Direction = "Inbound"
    $syncRule.TargetObjectType = "person"
    $syncRule.SourceObjectType = "user"
    $syncRule.LinkType = "Join"
    $syncRule.Precedence = 100
    $syncRule.Disabled = $false
    $syncRule.Ensure = "Present"

    Write-Host "Calling Set() method..."
    $syncRule.Set()

    Write-Host "Set() method completed."
    Write-Host "Event log calls made: $($global:EventLogCalls.Count)"

    if ($global:EventLogCalls.Count -gt 0) {
        Write-Host "Event log calls:"
        $global:EventLogCalls | ForEach-Object {
            Write-Host "  - EventId: $($_.EventId), Message: $($_.Message)"
        }
    } else {
        Write-Host "❌ No event log calls were made!"
    }

} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
}
