
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

    [DscProperty(Mandatory = $true)]
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

    [DscProperty(NotConfigurable)]
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

        $param.ExcludeProperties = 'Precedence', 'Version', 'Identifier', 'Connector', 'IsStandardRule', 'IsLegacyCustomRule'
        #Wait-Debugger
        $compare = Test-DscParameterState @param -ReverseCheck

        return $compare
    }

    [AADSyncRule]Get()
    {

        $syncRule = Get-ADSyncRule -Name $this.Name

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

        $currentState.Direction = $syncRule.Direction
        $currentState.EnablePasswordSync = $syncRule.EnablePasswordSync
        $currentState.Identifier = $syncRule.Identifier
        $currentState.Description = $syncRule.Description
        #$currentState.ImmutableTag
        $currentState.LinkType = $syncRule.LinkType
        $currentState.Precedence = $syncRule.Precedence

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

        $existingRule = Get-ADSyncRule -Name $this.Name
        $this.Identifier = if ($existingRule)
        {
            $existingRule.Identifier
        }
        else
        {
            New-Guid2 -InputString $this.Name
        }

        $allParameters = Convert-ObjectToHashtable $this
        #$allParameters.ScopeFilter = $this.ScopeFilter.ScopeConditionList.ForEach({
        #        [ScopeCondition]::new($_.Attribute, $_.ComparisonValue, $_.ComparisonOperator)
        #})
        #$allParameters.JoinFilter = $this.JoinFilter.ForEach({
        #        [JoinCondition]::new($_.CSAttribute, $_.MVAttribute, $_.CaseSensitive)
        #})
        #$this.Identifier = New-Guid2 -InputString $this.Name

        if ($this.Ensure -eq 'Present')
        {

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

            if ($existingRule)
            {
                Remove-ADSyncRule -Identifier $rule.Identifier
            }

            $rule | Add-ADSyncRule
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