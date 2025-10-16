<#
.EXAMPLE 1

This example creates a basic inbound sync rule for users from Active Directory.
The rule includes scope filtering to only sync employees and sets up basic
attribute flow mappings.
#>

configuration Example_AADSyncRule_Basic
{
    Import-DscResource -ModuleName AADConnectDsc

    node localhost
    {
        AADSyncRule 'BasicUserRule'
        {
            Name                  = 'Example - Inbound - User - Basic'
            ConnectorName         = 'contoso.com'
            Description           = 'Basic user sync rule example'
            Direction             = 'Inbound'
            TargetObjectType      = 'person'
            SourceObjectType      = 'user'
            LinkType              = 'Provision'
            Precedence            = 0
            Disabled              = $false

            # Scope filter - only sync enabled employees
            ScopeFilter           = @(
                @{
                    ScopeConditionList = @(
                        @{
                            Attribute          = 'userAccountControl'
                            ComparisonOperator = 'NOTEQUAL'
                            ComparisonValue    = '514'  # Account disabled
                        },
                        @{
                            Attribute          = 'employeeType'
                            ComparisonOperator = 'EQUAL'
                            ComparisonValue    = 'Employee'
                        }
                    )
                }
            )

            # Basic attribute mappings
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
                    Source      = 'mail'
                    Destination = 'mail'
                    FlowType    = 'Direct'
                }
            )

            Ensure                = 'Present'
        }
    }
}
