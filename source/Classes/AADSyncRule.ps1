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
        $currentState = Convert-ObjectToHashtable -Object $this.Get()
        $desiredState = Convert-ObjectToHashtable -Object $this

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

        #Remove all whitespace from description , otherwise they will not match due to encoding differences
        if (-not [string]::IsNullOrEmpty($currentState.Description))
        {
            $currentState.Description = $currentState.Description -replace '\s', ''
        }

        if (-not [string]::IsNullOrEmpty($desiredState.Description))
        {
            $desiredState.Description = $desiredState.Description -replace '\s', ''
        }

        if ($currentState.Ensure -ne $desiredState.Ensure)
        {
            return $false
        }
        if ($desiredState.Ensure -eq [Ensure]::Absent)
        {
            return $true
        }

        $param = @{
            CurrentValues       = $currentState
            DesiredValues       = $desiredState
            TurnOffTypeChecking = $true
            SortArrayValues     = $true
        }

        $param.ExcludeProperties = if ($this.IsStandardRule)
        {
            $this.GetType().GetProperties().Name | Where-Object { $_ -in 'Connector', 'Version', 'Identifier' }
        }
        else
        {
            'Connector', 'Version', 'Identifier'
        }

        $compare = Test-DscParameterState @param -ReverseCheck

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
        $this.Connector = (Get-ADSyncConnector | Where-Object Name -EQ $this.ConnectorName).Identifier

        $existingRule = Get-ADSyncRule -Name $this.Name -ConnectorName $this.ConnectorName
        $this.Identifier = if ($existingRule)
        {
            $existingRule.Identifier
        }
        else
        {
            New-Guid2 -InputString $this.Name
        }

        $allParameters = Convert-ObjectToHashtable -Object $this

        if ($this.Ensure -eq 'Present')
        {
            if ($this.IsStandardRule)
            {
                if ($null -eq $existingRule)
                {
                    Write-Error "A syncrule defined as 'IsStandardRule' does not exist. It cannot be enabled or disabled."
                    return
                }

                Write-Warning "The only property changed on a standard rule is 'Disabled'. All other configuration drifts will not be corrected."
                $existingRule.Disabled = $this.Disabled
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
                $param = Sync-Parameter -Command $cmdet -Parameters $allParameters
                $rule = New-ADSyncRule @param

                if ($this.ScopeFilter)
                {
                    foreach ($scg in $this.ScopeFilter)
                    {
                        $scopeConditions = foreach ($sc in $scg.ScopeConditionList)
                        {
                            [Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition]::new($sc.Attribute, $sc.ComparisonValue, $sc.ComparisonOperator)
                        }

                        $rule | Add-ADSyncScopeConditionGroup -ScopeConditions $scopeConditions
                    }
                }

                if ($this.JoinFilter)
                {
                    foreach ($jcg in $this.JoinFilter)
                    {
                        $joinConditions = foreach ($jc in $jcg.JoinConditionList)
                        {
                            [Microsoft.IdentityManagement.PowerShell.ObjectModel.JoinCondition]::new($jc.CSAttribute, $jc.MVAttribute, $jc.CaseSensitive)
                        }

                        $rule | Add-ADSyncJoinConditionGroup -JoinConditions $joinConditions
                    }

                }

                if ($this.AttributeFlowMappings)
                {
                    foreach ($af in $this.AttributeFlowMappings)
                    {
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
