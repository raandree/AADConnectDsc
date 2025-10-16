# Function Documentation

This section provides comprehensive documentation for all public functions in
the AADConnectDsc module. These functions support the DSC resources and provide
additional capabilities for managing Azure AD Connect configurations.

**Important**: All functions require Windows PowerShell 5.1 and do NOT work
with PowerShell 7 due to Azure AD Connect dependencies.

## Core Functions

### Get-ADSyncRule

Retrieves Azure AD Connect synchronization rules from the synchronization
engine.

#### Synopsis

```powershell
Get-ADSyncRule [[-Name] <string>] [[-Identifier] <guid>] [[-Direction] <string>] [[-ConnectorName] <string>]
```

#### Parameters

**Name** (String, Optional)

- The name of the synchronization rule to retrieve
- Supports wildcards
- Example: `'Custom - Inbound*'`

**Identifier** (Guid, Optional)  

- The unique identifier (GUID) of the synchronization rule
- Example: `'12345678-1234-1234-1234-123456789012'`

**Direction** (String, Optional)

- Filter by rule direction
- Valid values: `'Inbound'`, `'Outbound'`

**ConnectorName** (String, Optional)

- Filter by connector name
- Example: `'contoso.com'`

#### Examples

```powershell
# Get all sync rules
$allRules = Get-ADSyncRule

# Get specific rule by name
$rule = Get-ADSyncRule -Name 'In from AD - User Join'

# Get all inbound rules for a connector
$inboundRules = Get-ADSyncRule -Direction 'Inbound' -ConnectorName 'contoso.com'

# Get rule by identifier
$rule = Get-ADSyncRule -Identifier '12345678-1234-1234-1234-123456789012'
```

#### Returns

Returns `AADSyncRule` objects containing:

- Name
- Identifier  
- Direction
- ConnectorName
- TargetObjectType
- SourceObjectType
- LinkType
- Precedence
- ScopeFilter
- JoinFilter
- AttributeFlowMappings

## Directory Extension Functions

### Add-AADConnectDirectoryExtensionAttribute

Creates a new directory extension attribute for Azure AD Connect.

#### Synopsis

```powershell
Add-AADConnectDirectoryExtensionAttribute -Name <string> -AssignedObjectClass <string> -Type <string>
```

#### Parameters

**Name** (String, Required)

- The name of the extension attribute to create
- Must be unique within the schema
- Example: `'employeeID'`

**AssignedObjectClass** (String, Required)

- The object class to assign the attribute to
- Valid values: `'user'`, `'group'`, `'contact'`

**Type** (String, Required)

- The data type of the attribute
- Valid values: `'String'`, `'Integer'`, `'DateTime'`, `'Boolean'`, `'Binary'`

#### Examples

```powershell
# Create string attribute for users
Add-AADConnectDirectoryExtensionAttribute -Name 'costCenter' -AssignedObjectClass 'user' -Type 'String'

# Create datetime attribute for users
Add-AADConnectDirectoryExtensionAttribute -Name 'hireDate' -AssignedObjectClass 'user' -Type 'DateTime'

# Create boolean attribute for groups
Add-AADConnectDirectoryExtensionAttribute -Name 'isDistributionList' -AssignedObjectClass 'group' -Type 'Boolean'
```

#### Returns

Returns the created `AADConnectDirectoryExtensionAttribute` object.

### Get-AADConnectDirectoryExtensionAttribute

Retrieves directory extension attributes from Azure AD Connect.

#### Synopsis

```powershell
Get-AADConnectDirectoryExtensionAttribute [[-Name] <string>] [[-AssignedObjectClass] <string>]
```

#### Parameters

**Name** (String, Optional)

- The name of the extension attribute to retrieve
- Supports wildcards
- Example: `'employee*'`

**AssignedObjectClass** (String, Optional)

- Filter by assigned object class
- Valid values: `'user'`, `'group'`, `'contact'`

#### Examples

```powershell
# Get all extension attributes
$allAttributes = Get-AADConnectDirectoryExtensionAttribute

# Get specific attribute
$attribute = Get-AADConnectDirectoryExtensionAttribute -Name 'employeeID'

# Get all user attributes
$userAttributes = Get-AADConnectDirectoryExtensionAttribute -AssignedObjectClass 'user'

# Get attributes with pattern
$employeeAttrs = Get-AADConnectDirectoryExtensionAttribute -Name 'employee*'
```

#### Returns

Returns `AADConnectDirectoryExtensionAttribute` objects containing:

- Name
- AssignedObjectClass
- Type
- IsEnabled

### Remove-AADConnectDirectoryExtensionAttribute

Removes a directory extension attribute from Azure AD Connect.

#### Synopsis

```powershell
Remove-AADConnectDirectoryExtensionAttribute -Name <string> -AssignedObjectClass <string>
```

#### Parameters

**Name** (String, Required)

- The name of the extension attribute to remove
- Example: `'employeeID'`

**AssignedObjectClass** (String, Required)

- The object class the attribute is assigned to
- Valid values: `'user'`, `'group'`, `'contact'`

#### Examples

```powershell
# Remove user extension attribute
Remove-AADConnectDirectoryExtensionAttribute -Name 'oldField' -AssignedObjectClass 'user'

# Remove group extension attribute
Remove-AADConnectDirectoryExtensionAttribute -Name 'groupCategory' -AssignedObjectClass 'group'
```

#### Notes

- Removing extension attributes that are referenced in sync rules may cause
  synchronization errors
- Verify no active sync rules reference the attribute before removal

## Utility Functions

### Convert-ObjectToHashtable

Converts PowerShell objects to hashtables for configuration purposes.

#### Synopsis

```powershell
Convert-ObjectToHashtable -InputObject <object>
```

#### Parameters

**InputObject** (Object, Required)

- The object to convert to a hashtable
- Can be any PowerShell object

#### Examples

```powershell
# Convert custom object to hashtable
$obj = [PSCustomObject]@{
    Name = 'Test'
    Value = 123
}
$hashtable = Convert-ObjectToHashtable -InputObject $obj

# Convert sync rule to hashtable for configuration
$rule = Get-ADSyncRule -Name 'Test Rule'
$config = Convert-ObjectToHashtable -InputObject $rule
```

#### Returns

Returns a hashtable representation of the input object.

#### Notes

- Useful for creating DSC configuration from existing objects
- Handles nested objects and arrays
- Converts complex objects to serializable format

## Common Usage Patterns

### Discovering Existing Configuration

```powershell
# Get current sync rules for analysis
$rules = Get-ADSyncRule
$rules | Where-Object { $_.Name -like '*Custom*' } | 
    Select-Object Name, Direction, Precedence

# Get extension attributes for documentation
$extensions = Get-AADConnectDirectoryExtensionAttribute
$extensions | Format-Table Name, AssignedObjectClass, Type, IsEnabled
```

### Creating Configuration from Existing Setup

```powershell
# Export current rule configuration
$rule = Get-ADSyncRule -Name 'My Custom Rule'
$config = Convert-ObjectToHashtable -InputObject $rule

# Create DSC configuration block
@"
AADSyncRule '$($rule.Name.Replace(' ', '').Replace('-', ''))'
{
    Name = '$($rule.Name)'
    ConnectorName = '$($rule.ConnectorName)'
    Direction = '$($rule.Direction)'
    # ... additional properties
}
"@
```

### Validation and Testing

```powershell
# Verify extension attribute exists before creating sync rule
$attribute = Get-AADConnectDirectoryExtensionAttribute -Name 'employeeID'
if ($null -eq $attribute) {
    Write-Warning 'Extension attribute employeeID does not exist'
}

# Check for conflicting sync rules
$existingRule = Get-ADSyncRule -Name 'My Custom Rule'
if ($existingRule) {
    Write-Warning 'Rule with same name already exists'
}
```
