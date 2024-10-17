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
