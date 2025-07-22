<#
.SYNOPSIS
    Retrieves Azure AD Connect synchronization rules with enhanced filtering capabilities.

.DESCRIPTION
    The Get-ADSyncRule function provides a wrapper around the native ADSync\Get-ADSyncRule cmdlet,
    adding enhanced filtering capabilities by name and connector. This function supports multiple
    parameter sets for flexible rule retrieval and is designed to work with Windows PowerShell 5.1.
    
    This function is part of the AADConnectDsc module and requires an active Azure AD Connect
    installation with the ADSync PowerShell module available.

.PARAMETER Name
    Specifies the name of the synchronization rule to retrieve. When used alone, it searches
    across all connectors. When used with ConnectorName, it searches within the specified connector.

.PARAMETER Identifier
    Specifies the unique identifier (GUID) of the synchronization rule to retrieve.
    When specified, all other parameters are ignored.

.PARAMETER ConnectorName
    Specifies the name of the connector to filter synchronization rules.
    Can be used alone to get all rules for a connector, or with Name for specific rule lookup.

.EXAMPLE
    Get-ADSyncRule
    
    Retrieves all synchronization rules from Azure AD Connect.

.EXAMPLE
    Get-ADSyncRule -Name "In from AD - User Common"
    
    Retrieves the synchronization rule with the specified name from any connector.

.EXAMPLE
    Get-ADSyncRule -Identifier "12345678-1234-1234-1234-123456789012"
    
    Retrieves the synchronization rule with the specified GUID identifier.

.EXAMPLE
    Get-ADSyncRule -ConnectorName "contoso.com"
    
    Retrieves all synchronization rules associated with the specified connector.

.EXAMPLE
    Get-ADSyncRule -Name "In from AD - User Common" -ConnectorName "contoso.com"
    
    Retrieves the synchronization rule with the specified name from the specified connector.

.INPUTS
    None. You cannot pipe objects to Get-ADSyncRule.

.OUTPUTS
    Microsoft.IdentityManagement.PowerShell.ObjectModel.SynchronizationRule
    Returns synchronization rule objects that match the specified criteria.

.NOTES
    - This function requires Windows PowerShell 5.1 and does not work with PowerShell 7
    - Requires Azure AD Connect to be installed and the ADSync module to be available
    - The function provides enhanced error handling and parameter validation
    - Multiple parameter sets allow for flexible rule retrieval scenarios

.LINK
    https://docs.microsoft.com/en-us/azure/active-directory/hybrid/reference-connect-sync-functions-reference

.COMPONENT
    AADConnectDsc

.FUNCTIONALITY
    Azure AD Connect Synchronization Rule Management
#>
function Get-ADSyncRule
{
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByNameAndConnector')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByIdentifier')]
        [guid]
        $Identifier,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByNameAndConnector')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByConnector')]
        [string]
        $ConnectorName
    )

    $connectors = Get-ADSyncConnector

    if ($PSCmdlet.ParameterSetName -eq 'ByIdentifier')
    {
        ADSync\Get-ADSyncRule -Identifier $Identifier
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByName')
    {
        if ($Name)
        {
            ADSync\Get-ADSyncRule | Where-Object Name -EQ $Name
        }
        else
        {
            ADSync\Get-ADSyncRule
        }
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByConnector')
    {
        $connector = $connectors | Where-Object Name-eq $ConnectorName
        ADSync\Get-ADSyncRule | Where-Object Connector -EQ $connector.Identifier
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByNameAndConnector')
    {
        $connector = $connectors | Where-Object Name -EQ $ConnectorName
        if ($null -eq $connector)
        {
            Write-Error "The connector '$ConnectorName' does not exist"
            return
        }
        ADSync\Get-ADSyncRule | Where-Object { $_.Name -eq $Name -and $_.Connector -eq $connector.Identifier }
    }
    else
    {
        ADSync\Get-ADSyncRule
    }
}
