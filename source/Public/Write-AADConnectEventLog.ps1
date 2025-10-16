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
        - 2000: Information - Sync rule created successfully
        - 2001: Information - Sync rule updated successfully
        - 2002: Information - Standard sync rule disabled state changed
        - 2003: Information - Sync rule removed successfully

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
        $IsStandardRule,

        [Parameter()]
        [string]
        $Operation,

        [Parameter()]
        [int]
        $ScopeFilterCount,

        [Parameter()]
        [int]
        $JoinFilterCount,

        [Parameter()]
        [int]
        $AttributeFlowMappingCount,

        [Parameter()]
        [string]
        $RuleIdentifier
    )

    try
    {
        $logName = 'AADConnectDsc'
        $sourceName = 'AADConnectDsc'

        # Always write verbose output for debugging, even if event logging fails
        Write-Verbose "Attempting to write event log entry: EventType=$EventType, EventId=$EventId, SyncRule=$SyncRuleName"

        # Check if the event log exists, if not create it
        if (-not [System.Diagnostics.EventLog]::Exists($logName))
        {
            Write-Verbose "Event log '$logName' does not exist. Creating it now."
            try
            {
                New-EventLog -LogName $logName -Source $sourceName
                Write-Verbose "Event log '$logName' created successfully."
            }
            catch
            {
                Write-Warning "Failed to create event log '$logName': $($_.Exception.Message). This requires Administrator privileges."
                Write-Verbose "Event logging will be skipped. To enable event logging, run 'New-EventLog -LogName '$logName' -Source '$sourceName'' as Administrator."
                return
            }
        }
        elseif (-not [System.Diagnostics.EventLog]::SourceExists($sourceName))
        {
            Write-Verbose "Event source '$sourceName' does not exist in log '$logName'. Creating it now."
            try
            {
                New-EventLog -LogName $logName -Source $sourceName
                Write-Verbose "Event source '$sourceName' created successfully."
            }
            catch
            {
                Write-Warning "Failed to create event source '$sourceName': $($_.Exception.Message). This requires Administrator privileges."
                Write-Verbose "Event logging will be skipped. To enable event logging, run 'New-EventLog -LogName '$logName' -Source '$sourceName'' as Administrator."
                return
            }
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
                $ruleType = if ($IsStandardRule)
                {
                    'Microsoft Standard Rule'
                }
                else
                {
                    'Custom Rule'
                }
                $contextMessage += "`n  Rule Type: $ruleType"
            }

            if ($Operation)
            {
                $contextMessage += "`n  Operation: $Operation"
            }

            if ($RuleIdentifier)
            {
                $contextMessage += "`n  Rule Identifier: $RuleIdentifier"
            }

            # Add configuration complexity details for create/update operations
            if ($PSBoundParameters.ContainsKey('ScopeFilterCount'))
            {
                $contextMessage += "`n  Scope Filter Groups: $ScopeFilterCount"
            }

            if ($PSBoundParameters.ContainsKey('JoinFilterCount'))
            {
                $contextMessage += "`n  Join Filter Groups: $JoinFilterCount"
            }

            if ($PSBoundParameters.ContainsKey('AttributeFlowMappingCount'))
            {
                $contextMessage += "`n  Attribute Flow Mappings: $AttributeFlowMappingCount"
            }
        }

        # Write the event log entry
        try
        {
            Write-EventLog -LogName $logName -Source $sourceName -EventId $EventId -EntryType $EventType -Message $contextMessage
            Write-Verbose "✅ Event log entry written successfully: EventType=$EventType, EventId=$EventId, SyncRule=$SyncRuleName, Connector=$ConnectorName"
        }
        catch
        {
            Write-Warning "❌ Failed to write event log entry: $($_.Exception.Message). This typically requires Administrator privileges."
            Write-Verbose "To enable event logging, run PowerShell as Administrator or pre-create the event log with: New-EventLog -LogName '$logName' -Source '$sourceName'"

            # For debugging purposes, always log the event details to verbose output
            Write-Verbose 'Event details that would have been logged:'
            Write-Verbose "  EventType: $EventType"
            Write-Verbose "  EventId: $EventId"
            Write-Verbose "  Message: $contextMessage"
        }
    }
    catch
    {
        Write-Warning "❌ Event logging failed: $($_.Exception.Message)"
        Write-Verbose 'Event logging attempted but failed. DSC operation will continue normally.'
        # Don't throw - event logging should not break the main DSC operation
    }
}
