# Test script to verify sync rule Set() method and event logging
Import-Module ".\output\module\AADConnectDsc" -Force

# Mock the AAD Connect cmdlets since we don't have a real AAD Connect environment
function Get-ADSyncConnector {
    param($Name, $ErrorAction)
    return [PSCustomObject]@{
        Name = $Name
        Identifier = [guid]::NewGuid()
    }
}

function Get-ADSyncRule {
    param($Name, $ConnectorName)
    return $null  # Simulate no existing rule
}

function New-ADSyncRule {
    return [PSCustomObject]@{
        Name = "TestRule"
        Identifier = [guid]::NewGuid()
    }
}

function Add-ADSyncRule {
    param([Parameter(ValueFromPipeline)]$Rule)
    Write-Host "Mock: Adding sync rule $($Rule.Name)"
}

# Create a test sync rule
$syncRule = [AADSyncRule]::new()
$syncRule.Name = "TestSyncRule"
$syncRule.ConnectorName = "TestConnector"
$syncRule.Direction = "Inbound"
$syncRule.TargetObjectType = "person"
$syncRule.SourceObjectType = "user"
$syncRule.Precedence = 100
$syncRule.Disabled = $false
$syncRule.Ensure = "Present"

Write-Host "Testing AADSyncRule Set() method..."

try {
    $syncRule.Set()
    Write-Host "Set() method completed successfully"
} catch {
    Write-Host "Error in Set() method: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
}

Write-Host "Test completed"
