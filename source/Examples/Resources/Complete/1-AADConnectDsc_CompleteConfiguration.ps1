<#
.EXAMPLE 1

This example demonstrates a complete Azure AD Connect configuration using
both AADSyncRule and AADConnectDirectoryExtensionAttribute resources.
It creates custom directory extensions and then uses them in sync rules
for advanced attribute flow scenarios.
#>

configuration Example_AADConnectDsc_Complete
{
    Import-DscResource -ModuleName AADConnectDsc

    node localhost
    {
        # First, create directory extension attributes
        AADConnectDirectoryExtensionAttribute 'EmployeeIDExtension'
        {
            Name                = 'employeeID'
            AssignedObjectClass = 'user'
            type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }

        AADConnectDirectoryExtensionAttribute 'DepartmentCodeExtension'
        {
            Name                = 'departmentCode'
            AssignedObjectClass = 'user'
            type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }

        # Create a sync rule that uses the custom extensions
        AADSyncRule 'CustomEmployeeRule'
        {
            Name                  = 'Organization - Inbound - User - Employee'
            ConnectorName         = 'contoso.com'
            Description           = 'Custom employee sync rule using extensions'
            Direction             = 'Inbound'
            TargetObjectType      = 'person'
            SourceObjectType      = 'user'
            LinkType              = 'Provision'
            Precedence            = 10
            Disabled              = $false

            # Scope to employees only
            ScopeFilter           = @(
                @{
                    ScopeConditionList = @(
                        @{
                            Attribute          = 'employeeType'
                            ComparisonOperator = 'EQUAL'
                            ComparisonValue    = 'Employee'
                        },
                        @{
                            Attribute          = 'userAccountControl'
                            ComparisonOperator = 'NOTEQUAL'
                            ComparisonValue    = '514'  # Not disabled
                        }
                    )
                }
            )

            # Standard and custom attribute mappings
            AttributeFlowMappings = @(
                # Standard mappings
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
                },
                # Custom extension mappings
                @{
                    Source      = 'employeeNumber'
                    Destination = 'extension_employeeID'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'department'
                    Destination = 'extension_departmentCode'
                    FlowType    = 'Direct'
                },
                # Complex expression using custom data
                @{
                    Source      = ''
                    Destination = 'displayName'
                    FlowType    = 'Expression'
                    Expression  = 'IIF(IsNullOrEmpty([extension_employeeID]), Concatenate([givenName], " ", [sn]), Concatenate([givenName], " ", [sn], " (", [extension_employeeID], ")"))'
                }
            )

            Ensure                = 'Present'
            DependsOn             = '[AADConnectDirectoryExtensionAttribute]EmployeeIDExtension', '[AADConnectDirectoryExtensionAttribute]DepartmentCodeExtension'
        }

        # Create an outbound rule for Azure AD
        AADSyncRule 'CustomEmployeeOutbound'
        {
            Name                  = 'Organization - Outbound - User - Employee'
            ConnectorName         = 'contoso.com - AAD'
            Description           = 'Custom employee outbound rule to Azure AD'
            Direction             = 'Outbound'
            TargetObjectType      = 'user'
            SourceObjectType      = 'person'
            LinkType              = 'Provision'
            Precedence            = 11
            Disabled              = $false

            # Scope to provisioned employees
            ScopeFilter           = @(
                @{
                    ScopeConditionList = @(
                        @{
                            Attribute          = 'sourceObjectType'
                            ComparisonOperator = 'EQUAL'
                            ComparisonValue    = 'user'
                        }
                    )
                }
            )

            # Outbound attribute mappings
            AttributeFlowMappings = @(
                @{
                    Source      = 'firstName'
                    Destination = 'givenName'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'lastName'
                    Destination = 'surname'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'displayName'
                    Destination = 'displayName'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'mail'
                    Destination = 'mail'
                    FlowType    = 'Direct'
                },
                @{
                    Source      = 'extension_employeeID'
                    Destination = 'extensionAttribute1'
                    FlowType    = 'Direct'
                }
            )

            Ensure                = 'Present'
            DependsOn             = '[AADSyncRule]CustomEmployeeRule'
        }
    }
}
