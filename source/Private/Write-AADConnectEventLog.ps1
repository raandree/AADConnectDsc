function Write-AADConnectEventLog
{
    <#
    .SYNOPSIS
        Writes event log entries for AADConnectDsc module operations.

    .DESCRIPTION
        This function writes event log entries to a dedicated AADConnectDsc event log.
        It automatically creates the event log and source if they don't exist.
        The function is designed to track DSC resource compliance state changes
        and provide audit trails for Azure AD Connect synchronization rule management.

    .PARAMETER EventType
        The type of event to log. Valid values are 'Information', 'Warning', 'Error'.

    .PARAMETER EventId
        The event ID for the log entry. This should be unique for different types of events.
        Predefined Event IDs:
        - 1000: Information - Sync rule is in desired state and compliant
        - 1001: Warning - Sync rule is absent but should be present
        - 1002: Warning - Sync rule is present but should be absent
        - 1003: Warning - Sync rule configuration drift detected

    .PARAMETER Message
        The message to write to the event log.

    .PARAMETER SyncRuleName
        The name of the sync rule associated with this event.

    .PARAMETER ConnectorName
        The name of the connector associated with this event.

    .PARAMETER Direction
        The direction of the sync rule (Inbound/Outbound).

    .PARAMETER TargetObjectType
        The target object type of the sync rule.

    .PARAMETER SourceObjectType
        The source object type of the sync rule.

    .PARAMETER Precedence
        The precedence value of the sync rule.

    .PARAMETER Disabled
        Whether the sync rule is disabled.

    .PARAMETER IsStandardRule
        Whether this is a Microsoft standard rule.

    .EXAMPLE
        Write-AADConnectEventLog -EventType 'Warning' -EventId 1001 -Message "Sync rule is absent but should be present" -SyncRuleName 'MyRule' -ConnectorName 'MyConnector' -Direction 'Inbound' -TargetObjectType 'person'

    .EXAMPLE
        Write-AADConnectEventLog -EventType 'Warning' -EventId 1002 -Message "Sync rule is present but should be absent" -SyncRuleName 'MyRule' -ConnectorName 'MyConnector' -Direction 'Outbound' -Disabled $false

    .EXAMPLE
        Write-AADConnectEventLog -EventType 'Information' -EventId 1000 -Message "Sync rule is in desired state" -SyncRuleName 'MyRule' -ConnectorName 'MyConnector' -Precedence 100 -IsStandardRule $false
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]
        $EventType,

        [Parameter(Mandatory = $true)]
        [int]
        $EventId,

        [Parameter(Mandatory = $true)]
        [string]
        $Message,

        [Parameter()]
        [string]
        $SyncRuleName,

        [Parameter()]
        [string]
        $ConnectorName,

        [Parameter()]
        [string]
        $Direction,

        [Parameter()]
        [string]
        $TargetObjectType,

        [Parameter()]
        [string]
        $SourceObjectType,

        [Parameter()]
        [int]
        $Precedence,

        [Parameter()]
        [bool]
        $Disabled,

        [Parameter()]
        [bool]
        $IsStandardRule
    )

    try
    {
        $logName = 'AADConnectDsc'
        $sourceName = 'AADConnectDsc'

        # Check if the event log exists, if not create it
        if (-not [System.Diagnostics.EventLog]::Exists($logName))
        {
            Write-Verbose "Event log '$logName' does not exist. Creating it now."
            New-EventLog -LogName $logName -Source $sourceName
            Write-Verbose "Event log '$logName' created successfully."
        }
        elseif (-not [System.Diagnostics.EventLog]::SourceExists($sourceName))
        {
            Write-Verbose "Event source '$sourceName' does not exist in log '$logName'. Creating it now."
            New-EventLog -LogName $logName -Source $sourceName
            Write-Verbose "Event source '$sourceName' created successfully."
        }

        # Build the complete message with context in multi-line format
        $contextMessage = $Message

        if ($SyncRuleName -or $ConnectorName -or $Direction -or $TargetObjectType -or $SourceObjectType)
        {
            $contextMessage += "`n`nSync Rule Details:"

            if ($SyncRuleName)
            {
                $contextMessage += "`n  Rule Name: $SyncRuleName"
            }

            if ($ConnectorName)
            {
                $contextMessage += "`n  Connector: $ConnectorName"
            }

            if ($Direction)
            {
                $contextMessage += "`n  Direction: $Direction"
            }

            if ($TargetObjectType)
            {
                $contextMessage += "`n  Target Object Type: $TargetObjectType"
            }

            if ($SourceObjectType)
            {
                $contextMessage += "`n  Source Object Type: $SourceObjectType"
            }

            if ($PSBoundParameters.ContainsKey('Precedence'))
            {
                $contextMessage += "`n  Precedence: $Precedence"
            }

            if ($PSBoundParameters.ContainsKey('Disabled'))
            {
                $contextMessage += "`n  Disabled: $Disabled"
            }

            if ($PSBoundParameters.ContainsKey('IsStandardRule'))
            {
                $ruleType = if ($IsStandardRule) { "Microsoft Standard Rule" } else { "Custom Rule" }
                $contextMessage += "`n  Rule Type: $ruleType"
            }
        }

        # Write the event log entry
        Write-EventLog -LogName $logName -Source $sourceName -EventId $EventId -EntryType $EventType -Message $contextMessage

        Write-Verbose "Event log entry written successfully: EventType=$EventType, EventId=$EventId, SyncRule=$SyncRuleName, Connector=$ConnectorName"
    }
    catch
    {
        Write-Warning "Failed to write to event log: $($_.Exception.Message)"
        # Don't throw - event logging should not break the main DSC operation
    }
}
