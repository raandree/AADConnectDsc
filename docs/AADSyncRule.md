# AADSyncRule DSC Resource

## Description

The AADSyncRule DSC resource manages Azure AD Connect synchronization rules.
This resource enables declarative configuration of sync rules including scope
filters, join conditions, and attribute flow mappings. It supports both custom
sync rules and management of standard Microsoft-provided sync rules.

## Parameters

### Key Properties

#### Name

- **Data Type**: String
- **Required**: Yes
- **Description**: The unique name of the synchronization rule
- **Example**: `'Custom - Inbound - User - Employees'`

#### ConnectorName

- **Data Type**: String
- **Required**: Yes
- **Description**: The name of the connector this rule applies to
- **Example**: `'contoso.com'` or `'contoso.com - AAD'`

### Mandatory Properties

#### Direction

- **Data Type**: String
- **Required**: Yes
- **Allowed Values**: `'Inbound'`, `'Outbound'`
- **Description**: The direction of data flow for this rule
- **Example**: `'Inbound'` (AD to metaverse), `'Outbound'` (metaverse to AAD)

#### TargetObjectType

- **Data Type**: String
- **Required**: Yes
- **Description**: The object type in the target namespace
- **Note**: Metaverse for inbound, connector space for outbound
- **Common Values**: `'person'`, `'user'`, `'group'`, `'contact'`

#### SourceObjectType

- **Data Type**: String
- **Required**: Yes
- **Description**: The object type in the source namespace
- **Note**: Connector space for inbound, metaverse for outbound
- **Common Values**: `'user'`, `'group'`, `'contact'`, `'person'`

#### LinkType

- **Data Type**: String
- **Required**: Yes  
- **Allowed Values**: `'Provision'`, `'Join'`
- **Description**: Defines whether this rule provisions new objects or joins to existing ones

### Optional Properties

#### Description

- **Data Type**: String
- **Required**: No
- **Description**: Descriptive text for the synchronization rule
- **Example**: `'Custom rule for employee synchronization'`

#### Disabled

- **Data Type**: Boolean
- **Required**: No
- **Default**: `$false`
- **Description**: Whether the sync rule is disabled

#### Precedence

- **Data Type**: Integer
- **Required**: No
- **Description**: The precedence of the rule (lower numbers = higher priority). For custom rules, this is automatically assigned.

#### PrecedenceAfter / PrecedenceBefore

- **Data Type**: String
- **Required**: No
- **Description**: Name of another rule to set precedence relative to

#### EnablePasswordSync

- **Data Type**: Boolean
- **Required**: No
- **Default**: `$false`
- **Description**: Whether this rule enables password synchronization

#### IsStandardRule

- **Data Type**: Boolean
- **Required**: No
- **Default**: `$false`
- **Description**: Whether this is a Microsoft standard rule (read-only except for Disabled property)

#### ImmutableTag

- **Data Type**: String
- **Required**: No
- **Description**: An immutable identifier tag for the rule

### Complex Properties

#### ScopeFilter

- **Data Type**: ScopeConditionGroup[]
- **Required**: No
- **Description**: Array of scope condition groups that determine which objects this rule applies to

**Structure**:
```powershell
ScopeFilter = @(
    @{
        ScopeConditionList = @(
            @{
                Attribute           = 'userAccountControl'
                ComparisonOperator  = 'NOTEQUAL'
                ComparisonValue     = '514'
            }
        )
    }
)
```

**Comparison Operators**: `EQUAL`, `NOTEQUAL`, `LESSTHAN`, `LESSTHANOREQUAL`, `GREATERTHAN`, `GREATERTHANOREQUAL`, `STARTSWITH`, `ENDSWITH`, `CONTAINS`, `NOTCONTAINS`, `ISBITSET`, `ISBITNOTSET`

#### JoinFilter

- **Data Type**: JoinConditionGroup[]
- **Required**: No
- **Description**: Array of join condition groups that define how objects are linked

**Structure**:
```powershell
JoinFilter = @(
    @{
        JoinConditionList = @(
            @{
                CSAttribute     = 'objectSid'
                MVAttribute     = 'objectSid' 
                CaseSensitive   = $false
            }
        )
    }
)
```

#### AttributeFlowMappings

- **Data Type**: AttributeFlowMapping[]
- **Required**: No
- **Description**: Array of attribute flow mappings that define how attribute values are transformed

**Structure**:
```powershell
AttributeFlowMappings = @(
    @{
        Source          = 'givenName'
        Destination     = 'firstName'
        FlowType        = 'Direct'
    },
    @{
        Source          = ''
        Destination     = 'displayName'
        FlowType        = 'Expression'
        Expression      = 'Concatenate([givenName], " ", [sn])'
    }
)
```

**Flow Types**: `Direct`, `Expression`, `Constant`

### Read-Only Properties

#### Identifier

- **Data Type**: String
- **Description**: The GUID identifier of the sync rule (auto-generated)

#### Version  

- **Data Type**: String
- **Description**: The version number of the sync rule

#### Connector

- **Data Type**: String
- **Description**: The GUID identifier of the connector

#### IsLegacyCustomRule

- **Data Type**: Boolean
- **Description**: Whether this is a legacy custom rule

## Examples

### Example 1: Basic User Sync Rule

```powershell
AADSyncRule 'BasicUserRule'
{
    Name                = 'Custom - Inbound - User - Basic'
    ConnectorName       = 'contoso.com'
    Direction           = 'Inbound'
    TargetObjectType    = 'person'
    SourceObjectType    = 'user'
    LinkType            = 'Provision'
    
    ScopeFilter         = @(
        @{
            ScopeConditionList = @(
                @{
                    Attribute           = 'employeeType'
                    ComparisonOperator  = 'EQUAL'
                    ComparisonValue     = 'Employee'
                }
            )
        }
    )
    
    AttributeFlowMappings = @(
        @{
            Source      = 'givenName'
            Destination = 'firstName'
            FlowType    = 'Direct'
        },
        @{
            Source      = 'mail'
            Destination = 'mail'
            FlowType    = 'Direct'
        }
    )
    
    Ensure              = 'Present'
}
```

### Example 2: Advanced Rule with Expressions

```powershell
AADSyncRule 'AdvancedUserRule'
{
    Name                = 'Custom - Inbound - User - Advanced'
    ConnectorName       = 'contoso.com'
    Direction           = 'Inbound'
    TargetObjectType    = 'person'
    SourceObjectType    = 'user'
    LinkType            = 'Provision'
    
    AttributeFlowMappings = @(
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
    
    Ensure              = 'Present'
}
```

## Notes

- Custom sync rules automatically receive precedence values starting from 0
- Standard rules can only have their `Disabled` property modified
- Scope filters use AND logic within a group, OR logic between groups
- Join conditions are used with `Join` LinkType rules
- Expression syntax follows Azure AD Connect transformation functions

