<#
.EXAMPLE 1

This example creates a complex sync rule with multiple scope conditions,
join conditions, and attribute flow expressions including PowerShell functions.
#>

configuration Example_AADSyncRule_Advanced
{
    Import-DscResource -ModuleName AADConnectDsc

    node localhost
    {
        AADSyncRule 'AdvancedUserRule'
        {
            Name                  = 'Example - Inbound - User - Advanced'
            ConnectorName         = 'contoso.com'
            Description           = 'Advanced user sync rule with complex mappings'
            Direction             = 'Inbound'
            TargetObjectType      = 'person'
            SourceObjectType      = 'user'
            LinkType              = 'Provision'
            Precedence            = 1
            Disabled              = $false

            # Complex scope filter with multiple conditions
            ScopeFilter           = @(
                @{
                    ScopeConditionList = @(
                        @{
                            Attribute          = 'userAccountControl'
                            ComparisonOperator = 'NOTEQUAL'
                            ComparisonValue    = '514'  # Not disabled
                        },
                        @{
                            Attribute          = 'department'
                            ComparisonOperator = 'STARTSWITH'
                            ComparisonValue    = 'IT'
                        }
                    )
                },
                @{
                    ScopeConditionList = @(
                        @{
                            Attribute          = 'extensionAttribute1'
                            ComparisonOperator = 'EQUAL'
                            ComparisonValue    = 'SyncEnabled'
                        }
                    )
                }
            )

            # Join condition for object linking
            JoinFilter            = @(
                @{
                    JoinConditionList = @(
                        @{
                            CSAttribute   = 'objectSid'
                            MVAttribute   = 'objectSid'
                            CaseSensitive = $false
                        }
                    )
                }
            )

            # Advanced attribute mappings with expressions
            AttributeFlowMappings = @(
                @{
                    Source      = 'givenName'
                    Destination = 'firstName'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'sn'
                    Destination = 'lastName'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = ''
                    Destination = 'displayName'
                    FlowType    = 'Expression'
                    Expression  = 'Concatenate([givenName], " ", [sn])'
                },
                @{
                    Source      = ''
                    Destination = 'userPrincipalName'
                    FlowType    = 'Expression'
                    Expression  = 'Concatenate([sAMAccountName], "@", "contoso.com")'
                }
            )

            Ensure                = 'Present'
        }
    }
}
