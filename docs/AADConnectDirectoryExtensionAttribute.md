# AADConnectDirectoryExtensionAttribute DSC Resource

## Description

The AADConnectDirectoryExtensionAttribute DSC resource manages directory
extension attributes for Azure AD Connect. Directory extensions allow you to
extend the Azure AD schema with custom attributes that can be synchronized
between on-premises Active Directory and Azure AD.

## Parameters

### Key Properties

#### Name

- **Data Type**: String
- **Required**: Yes
- **Description**: The name of the directory extension attribute
- **Example**: `'employeeID'`, `'costCenter'`, `'customField1'`

#### AssignedObjectClass

- **Data Type**: String  
- **Required**: Yes
- **Description**: The object class this attribute is assigned to
- **Common Values**: `'user'`, `'group'`, `'contact'`
- **Example**: `'user'`

### Mandatory Properties

#### Type

- **Data Type**: String
- **Required**: Yes
- **Description**: The data type of the extension attribute
- **Allowed Values**: `'String'`, `'Integer'`, `'DateTime'`, `'Boolean'`, `'Binary'`
- **Example**: `'String'`

#### IsEnabled

- **Data Type**: Boolean
- **Required**: Yes
- **Description**: Whether the directory extension attribute is enabled
- **Example**: `$true`

### Optional Properties

#### Ensure

- **Data Type**: String
- **Required**: No
- **Default**: `'Present'`
- **Allowed Values**: `'Present'`, `'Absent'`
- **Description**: Whether the directory extension attribute should exist

## Examples

### Example 1: Basic String Extension

```powershell
AADConnectDirectoryExtensionAttribute 'EmployeeIDExtension'
{
    Name                = 'employeeID'
    AssignedObjectClass = 'user'
    Type                = 'String'
    IsEnabled           = $true
    Ensure              = 'Present'
}
```

### Example 2: Multiple Extensions for User Object

```powershell
Configuration MultipleExtensions
{
    Import-DscResource -ModuleName AADConnectDsc

    Node localhost
    {
        AADConnectDirectoryExtensionAttribute 'CostCenterExtension'
        {
            Name                = 'costCenter'
            AssignedObjectClass = 'user'
            Type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
        
        AADConnectDirectoryExtensionAttribute 'HireDateExtension'
        {
            Name                = 'hireDate'
            AssignedObjectClass = 'user'  
            Type                = 'DateTime'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
        
        AADConnectDirectoryExtensionAttribute 'IsContractorExtension'
        {
            Name                = 'isContractor'
            AssignedObjectClass = 'user'
            Type                = 'Boolean'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
    }
}
```

### Example 3: Group Extension Attribute

```powershell
AADConnectDirectoryExtensionAttribute 'GroupCategoryExtension'
{
    Name                = 'groupCategory'
    AssignedObjectClass = 'group'
    Type                = 'String'
    IsEnabled           = $true
    Ensure              = 'Present'
}
```

### Example 4: Remove Extension Attribute

```powershell
AADConnectDirectoryExtensionAttribute 'ObsoleteExtension'
{
    Name                = 'oldField'
    AssignedObjectClass = 'user'
    Type                = 'String'
    IsEnabled           = $false
    Ensure              = 'Absent'
}
```

## Usage in Sync Rules

Once created, directory extension attributes can be referenced in AADSyncRule
attribute flow mappings using the `extension_` prefix:

```powershell
AttributeFlowMappings = @(
    @{
        Source      = 'employeeNumber'
        Destination = 'extension_employeeID'
        FlowType    = 'Direct'
    },
    @{
        Source      = 'department'
        Destination = 'extension_costCenter'
        FlowType    = 'Direct'
    }
)
```

## Notes

- Extension attributes must be created before they can be used in sync rules
- The attribute name in sync rules is prefixed with `extension_`
- Changes to extension attributes may require Azure AD Connect service restart
- Extension attributes are visible in the Azure AD portal under user properties
- Be careful when removing extension attributes that are in use by sync rules
