function Get-ADSyncRule {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(ParameterSetName = 'ByName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByIdentifier')]
        [guid]
        $Identifier
    )

    if ($Identifier) {
        ADSync\Get-ADSyncRule -Identifier $Identifier
    }
    elseif ($Name) {
        ADSync\Get-ADSyncRule | Where-Object Name -eq $Name
    }
    else {
        ADSync\Get-ADSyncRule
    }
}
