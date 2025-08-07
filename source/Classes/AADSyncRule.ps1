[DscResource()]
class AADSyncRule
{
    [DscProperty(Key = $true)]
    [string]$Name

    [DscProperty()]
    [string]$Description

    [DscProperty()]
    [bool]$Disabled

    [DscProperty(NotConfigurable)]
    [string]$Identifier

    [DscProperty(NotConfigurable)]
    [string]$Version

    [DscProperty()]
    [ScopeConditionGroup[]]$ScopeFilter

    [DscProperty()]
    [JoinConditionGroup[]]$JoinFilter

    [DscProperty()]
    [AttributeFlowMapping[]]$AttributeFlowMappings

    [DscProperty(Key = $true)]
    [string]$ConnectorName

    [DscProperty(NotConfigurable)]
    [string]$Connector

    [DscProperty()]
    [int]$Precedence

    [DscProperty()]
    [string]$PrecedenceAfter

    [DscProperty()]
    [string]$PrecedenceBefore

    [DscProperty(Mandatory = $true)]
    [string]$TargetObjectType

    [DscProperty(Mandatory = $true)]
    [string]$SourceObjectType

    [DscProperty(Mandatory = $true)]
    [string]$Direction

    [DscProperty(Mandatory = $true)]
    [string]$LinkType

    [DscProperty()]
    [bool]$EnablePasswordSync

    [DscProperty()]
    [string]$ImmutableTag

    [DscProperty()]
    [bool]$IsStandardRule

    [DscProperty(NotConfigurable)]
    [bool]$IsLegacyCustomRule

    [DscProperty()]
    [Ensure]$Ensure

    AADSyncRule()
    {
        $this.Ensure = 'Present'
    }

    [bool]Test()
    {
        $currentState = $this.Get() | ConvertTo-Yaml | ConvertFrom-Yaml
        $desiredState = $this | ConvertTo-Yaml | ConvertFrom-Yaml

        #Remove all whitespace from expressions in AttributeFlowMappings, otherwise they will not match due to encoding differences
        foreach ($afm in $currentState.AttributeFlowMappings)
        {
            if (-not [string]::IsNullOrEmpty($afm.Expression))
            {
                $afm.Expression = $afm.Expression -replace '\s', ''
            }
        }

        foreach ($afm in $desiredState.AttributeFlowMappings)
        {
            if (-not [string]::IsNullOrEmpty($afm.Expression))
            {
                $afm.Expression = $afm.Expression -replace '\s', ''
            }
        }

        $param = @{
            CurrentValues       = $currentState
            DesiredValues       = $desiredState
            TurnOffTypeChecking = $true
            SortArrayValues     = $true
        }

        $param.ExcludeProperties = if ($this.IsStandardRule)
        {
            ($this | Get-Member -MemberType Property).Name | Where-Object { $_ -notin 'Name', 'Disabled' }
        }
        else
        {
            'Connector', 'Version', 'Identifier'
        }

        $compare = if ($currentState.Ensure -eq $desiredState.Ensure)
        {
            if ($desiredState.Ensure -eq 'Present')
            {
                Write-Verbose "The sync rule '$($this.Name)' exists and should exist, comparing rule with 'Test-DscParameterState'."
                Test-DscParameterState @param -ReverseCheck

                if ($this.IsStandardRule)
                {
                    $param.ExcludeProperties = 'Connector', 'Version', 'Identifier', 'Precedence'
                    Write-Verbose '-----------------------------------------------------------------------------------------------------'
                    Write-Verbose '--------------------------- Comparing all properties for standard rule ------------------------------'
                    Write-Verbose '----------------------- The result will not effect the overall test result --------------------------'
                    Write-Verbose '-----------------------------------------------------------------------------------------------------'
                    $result = Test-DscParameterState @param -ReverseCheck
                    Write-Verbose '-----------------------------------------------------------------------------------------------------'
                    Write-Verbose "---- Test-DscParameterState returned '$result', but a negative value is not returned to the LCM -----"
                    Write-Verbose '-----------------------------------------------------------------------------------------------------'
                }
            }
            else
            {
                Write-Verbose "The sync rule '$($this.Name)' is absent and should be absent."
                $true
            }
        }
        else
        {
            if ($desiredState.Ensure -eq 'Present')
            {
                Write-Verbose "The sync rule '$($this.Name)' for connector '$($this.ConnectorName)' is absent, but should be present."
            }
            else
            {
                Write-Verbose "The sync rule '$($this.Name)' for connector '$($this.ConnectorName)' is present, but should be absent."
            }
            $false
        }

        return $compare
    }

    [AADSyncRule]Get()
    {
        $syncRule = Get-ADSyncRule -Name $this.Name -ConnectorName $this.ConnectorName

        $currentState = [AADSyncRule]::new()
        $currentState.Name = $this.Name

        if ($syncRule.Count -gt 1)
        {
            Write-Error "There is more than one sync rule with the name '$($this.Name)'."
            $currentState.Ensure = 'Unknown'
            return $currentState
        }

        $currentState.Ensure = [Ensure][int][bool]$syncRule

        $currentState.ConnectorName = (Get-ADSyncConnector | Where-Object Identifier -EQ $syncRule.Connector).Name
        $currentState.Connector = $syncRule.Connector

        $currentState.Description = $syncRule.Description
        $currentState.Disabled = $syncRule.Disabled
        $currentState.Direction = $syncRule.Direction
        $currentState.EnablePasswordSync = $syncRule.EnablePasswordSync
        $currentState.Identifier = $syncRule.Identifier
        $currentState.LinkType = $syncRule.LinkType
        $currentState.Precedence = $syncRule.Precedence

        $currentState.ScopeFilter = @()
        foreach ($scg in $syncRule.ScopeFilter)
        {
            $scg2 = [ScopeConditionGroup]::new()
            foreach ($sc in $scg.ScopeConditionList)
            {
                $sc2 = [ScopeCondition]::new($sc.Attribute, $sc.ComparisonValue, $sc.ComparisonOperator)
                $scg2.ScopeConditionList += $sc2
            }

            $currentState.ScopeFilter += $scg2
        }

        $currentState.JoinFilter = @()
        foreach ($jcg in $syncRule.JoinFilter)
        {
            $jcg2 = [JoinConditionGroup]::new()
            foreach ($jc in $jcg.JoinConditionList)
            {
                $jc2 = [JoinCondition]::new($jc.CSAttribute, $jc.MVAttribute, $jc.CaseSensitive)
                $jcg2.JoinConditionList += $jc2
            }

            $currentState.JoinFilter += $jcg2
        }

        $currentState.AttributeFlowMappings = @()
        foreach ($af in $syncRule.AttributeFlowMappings)
        {
            $af2 = [AttributeFlowMapping]::new()
            $af2.Source = $af.Source[0]
            $af2.Destination = $af.Destination
            $af2.ExecuteOnce = $af.ExecuteOnce
            $af2.FlowType = $af.FlowType
            $af2.ValueMergeType = $af.ValueMergeType
            if ($null -eq $af.Expression)
            {
                $af2.Expression = ''
            }
            else
            {
                $af2.Expression = $af.Expression
            }

            $currentState.AttributeFlowMappings += $af2
        }

        $currentState.SourceObjectType = $syncRule.SourceObjectType
        $currentState.TargetObjectType = $syncRule.TargetObjectType
        $currentState.Version = $syncRule.Version
        $currentState.IsStandardRule = $syncRule.IsStandardRule
        $currentState.IsLegacyCustomRule = $syncRule.IsLegacyCustomRule

        return $currentState
    }

    [void]Set()
    {
        $connectorObject = Get-ADSyncConnector -Name $this.ConnectorName -ErrorAction SilentlyContinue
        if ($null -eq $connectorObject)
        {
            Write-Error "The connector '$($this.ConnectorName)' does not exist."
            return
        }

        $this.Connector = $connectorObject.Identifier
        Write-Verbose "Got connector '$($this.ConnectorName)' for rule '$($this.Name)' with identifier '$($this.Connector)'."

        $existingRule = Get-ADSyncRule -Name $this.Name -ConnectorName $this.ConnectorName
        if ($existingRule)
        {
            Write-Verbose "Got existing rule '$($existingRule.Name)' with identifier '$($existingRule.Identifier)' for connector '$($this.ConnectorName)'."
            $this.Identifier = $existingRule.Identifier
        }
        else
        {
            $this.Identifier = New-Guid2 -InputString "$($this.Name)$($this.ConnectorName)"
            Write-Verbose "No existing rule found with the name '$($this.Name)'. Using identifier '$($this.Identifier)'."
        }

        $desiredState = Convert-ObjectToHashtable -Object $this

        if ($this.Ensure -eq 'Present')
        {
            Write-Verbose "The sync rule '$($this.Name)' should be present for connector '$($this.ConnectorName)'. Proceeding with creation or update."
            if ($this.IsStandardRule)
            {
                if ($null -eq $existingRule)
                {
                    Write-Error "A Sync Rule defined as 'IsStandardRule' does not exist. It cannot be enabled or disabled."
                    return
                }

                Write-Warning "The only property that will be changed on a standard rule is 'Disabled'. All other configuration drifts will not be corrected."
                $existingRule.Disabled = $this.Disabled
                Write-Verbose "Setting the 'Disabled' property of the rule '$($this.Name)' to '$($this.Disabled)' and calling 'Add-ADSyncRule'."
                $existingRule | Add-ADSyncRule
            }
            else
            {
                if ($existingRule.IsStandardRule)
                {
                    Write-Error 'It is not allowed to modify a standard rule. It can only be enabled or disabled.'
                    return
                }

                $cmdet = Get-Command -Name New-ADSyncRule
                $param = Sync-Parameter -Command $cmdet -Parameters $desiredState
                $rule = New-ADSyncRule @param

                if ($this.ScopeFilter)
                {
                    $i = 0
                    foreach ($scg in $this.ScopeFilter)
                    {
                        Write-Verbose "Processing ScopeConditionList $i"
                        $scopeConditions = foreach ($sc in $scg.ScopeConditionList)
                        {
                            Write-Verbose "Processing ScopeFilter: Attribute = '$($sc.Attribute)', ComparisonValue = '$($sc.ComparisonValue)', ComparisonOperator = '$($sc.ComparisonOperator)'"
                            [Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition]::new($sc.Attribute, $sc.ComparisonValue, $sc.ComparisonOperator)
                        }
                        Write-Verbose "ScopeConditionList count is $($scopeConditions.Count)"
                        $rule | Add-ADSyncScopeConditionGroup -ScopeConditions $scopeConditions
                        $i++
                    }
                }

                if ($this.JoinFilter)
                {
                    $i = 0
                    foreach ($jcg in $this.JoinFilter)
                    {
                        Write-Verbose "Processing JoinConditionList $i"
                        $joinConditions = foreach ($jc in $jcg.JoinConditionList)
                        {
                            Write-Verbose "Processing JoinFilter: CSAttribute = '$($jc.CSAttribute)', MVAttribute = '$($jc.MVAttribute)', CaseSensitive = '$($jc.CaseSensitive)'"
                            [Microsoft.IdentityManagement.PowerShell.ObjectModel.JoinCondition]::new($jc.CSAttribute, $jc.MVAttribute, $jc.CaseSensitive)
                        }

                        Write-Verbose "JoinConditionList count is $($joinConditions.Count)"
                        $rule | Add-ADSyncJoinConditionGroup -JoinConditions $joinConditions
                    }

                }

                if ($this.AttributeFlowMappings)
                {
                    $i = 0
                    foreach ($af in $this.AttributeFlowMappings)
                    {
                        Write-Verbose "Processing AttributeFlowMapping $i, Source = '$($af.Source)', Destination = '$($af.Destination)', Expression = '$($af.Expression)'"
                        $afHashTable = Convert-ObjectToHashtable -Object $af
                        $param = Sync-Parameter -Command (Get-Command -Name Add-ADSyncAttributeFlowMapping) -Parameters $afHashTable
                        $param.SynchronizationRule = $rule

                        if ([string]::IsNullOrEmpty($param.Expression))
                        {
                            $param.Remove('Expression')
                        }

                        if ([string]::IsNullOrEmpty($param.Source))
                        {
                            $param.Remove('Source')
                        }

                        Add-ADSyncAttributeFlowMapping @param
                    }

                }

                Write-Verbose "Calling 'Add-ADSyncRule' to create or update the rule '$($this.Name)'."
                $rule | Add-ADSyncRule
            }
        }
        else
        {
            if ($existingRule)
            {
                Remove-ADSyncRule -Identifier $this.Identifier
            }
        }
    }
}
