# AADConnectDsc Architecture

## Overview

AADConnectDsc is a PowerShell DSC module that provides declarative
configuration management for Azure AD Connect synchronization rules and
directory schema extensions. The module uses class-based DSC resources to
interface with the Azure AD Connect synchronization engine through the
ADSync PowerShell module.

## Module Architecture

### Core Components

```
AADConnectDsc/
├── Classes/                    # DSC Resource Classes
│   ├── AADSyncRule.ps1        # Sync rule management
│   ├── AADConnectDirectoryExtensionAttribute.ps1
│   ├── AttributeFlowMapping.ps1    # Supporting classes
│   ├── JoinCondition.ps1
│   ├── ScopeCondition.ps1
│   └── ...
├── Public/                     # Public Functions
│   ├── Get-ADSyncRule.ps1
│   ├── Add-AADConnectDirectoryExtensionAttribute.ps1
│   └── ...
├── Private/                    # Internal Functions
│   └── New-Guid2.ps1
└── Enum/                      # Enumerations
    ├── ComparisonOperator.ps1
    └── AttributeMappingFlowType.ps1
```

### Class-Based DSC Resources

The module implements DSC resources using PowerShell classes, which provides:

- **Strongly Typed Properties**: Compile-time validation of resource properties
- **Inheritance Support**: Shared functionality across resource classes
- **Better Performance**: Reduced overhead compared to MOF-based resources
- **Enhanced Debugging**: Better error messages and stack traces

#### Resource Inheritance Hierarchy

```
[DscResource()]
├── AADSyncRule
│   └── Properties: Name, ConnectorName, Direction, etc.
│   └── Methods: Get(), Set(), Test()
└── AADConnectDirectoryExtensionAttribute
    └── Properties: Name, AssignedObjectClass, Type, etc.
    └── Methods: Get(), Set(), Test()
```

### Supporting Classes

#### AttributeFlowMapping Class

Defines how attribute values flow between connector space and metaverse:

```powershell
class AttributeFlowMapping {
    [string] $Source
    [string] $Destination  
    [AttributeMappingFlowType] $FlowType
    [bool] $ExecuteOnce
    [AttributeValueMergeType] $MergeType
}
```

#### ScopeCondition Class

Defines filtering conditions for sync rule scope:

```powershell
class ScopeCondition {
    [string] $Attribute
    [ComparisonOperator] $Operator
    [string] $Value
}
```

#### JoinCondition Class

Defines conditions for joining objects across namespaces:

```powershell
class JoinCondition {
    [string] $CsAttribute      # Connector Space attribute
    [string] $MvAttribute      # Metaverse attribute
    [bool] $CaseSensitive
}
```

## Azure AD Connect Integration

### ADSync Module Dependency

The module depends on the Microsoft ADSync PowerShell module that is installed
with Azure AD Connect:

- **Installation Path**: `C:\Program Files\Microsoft Azure AD Sync\Bin\`
- **Key Cmdlets Used**:
  - `Get-ADSyncRule`
  - `New-ADSyncRule`
  - `Set-ADSyncRule`
  - `Remove-ADSyncRule`

### Synchronization Engine Integration

```
┌─────────────────────┐    ┌──────────────────────┐    ┌─────────────────┐
│   AADConnectDsc     │    │   ADSync Module      │    │ Sync Engine     │
│                     │    │                      │    │                 │
│ ┌─────────────────┐ │    │ ┌──────────────────┐ │    │ ┌─────────────┐ │
│ │ AADSyncRule     │─│────│▶│ *-ADSyncRule     │─│────│▶│ Rules DB    │ │
│ │ DSC Resource    │ │    │ │ Cmdlets          │ │    │ │             │ │
│ └─────────────────┘ │    │ └──────────────────┘ │    │ └─────────────┘ │
│                     │    │                      │    │                 │
│ ┌─────────────────┐ │    │ ┌──────────────────┐ │    │ ┌─────────────┐ │
│ │ DirectoryExt    │─│────│▶│ Schema Mgmt      │─│────│▶│ Schema DB   │ │
│ │ DSC Resource    │ │    │ │ Functions        │ │    │ │             │ │
│ └─────────────────┘ │    │ └──────────────────┘ │    │ └─────────────┘ │
└─────────────────────┘    └──────────────────────┘    └─────────────────┘
```

### Configuration Flow

1. **DSC Configuration Parse**: PowerShell DSC parses configuration
2. **Resource Instantiation**: Class-based resources are instantiated
3. **Current State Retrieval**: `Get()` method calls ADSync cmdlets
4. **Desired State Comparison**: `Test()` method compares current vs desired
5. **Configuration Application**: `Set()` method applies changes via ADSync
6. **Service Integration**: Changes are applied to synchronization engine

## PowerShell Requirements

### Version Requirements

- **Windows PowerShell 5.1**: Required for class-based DSC resources and
  Azure AD Connect integration
- **PowerShell 7 Incompatibility**: This module does NOT work with PowerShell 7
  due to Azure AD Connect dependencies
- **.NET Framework 4.5.2+**: Dependency of Azure AD Connect

### Module Dependencies

```powershell
RequiredModules = @(
    @{
        ModuleName    = 'ADSync'
        ModuleVersion = '1.1.0.0'
    }
)
```

## Error Handling Strategy

### Exception Hierarchy

```
AADConnectDscException
├── SyncRuleException
│   ├── SyncRuleNotFoundException
│   ├── SyncRuleValidationException
│   └── SyncRulePrecedenceException
└── DirectoryExtensionException
    ├── AttributeNotFoundException
    └── SchemaValidationException
```

### Retry Logic

- **Transient Errors**: Automatic retry with exponential backoff
- **Service Unavailable**: Wait for Azure AD Connect service
- **Concurrency Conflicts**: Serialize operations when possible

## Performance Considerations

### Optimization Strategies

1. **Bulk Operations**: Group related changes together
2. **Minimal Queries**: Cache results where appropriate
3. **Lazy Loading**: Load complex properties only when needed
4. **Connection Pooling**: Reuse ADSync module connections

### Resource Consumption

- **Memory Usage**: Minimal - resources are stateless
- **CPU Impact**: Low - delegates work to synchronization engine  
- **I/O Patterns**: Read-heavy during Get/Test, write-heavy during Set

## Security Model

### Permissions Required

- **Local Administrator**: Required for Azure AD Connect administration
- **ADSync Service Account**: Read/Write access to synchronization database
- **Azure AD Global Admin**: For initial Azure AD Connect setup

### Credential Management

- **Service Principal**: Recommended for automated scenarios
- **Managed Identity**: When running on Azure VMs
- **Certificate Authentication**: For enhanced security

## Deployment Patterns

### Single Server Deployment

```
┌─────────────────────────────────────┐
│ Azure AD Connect Server             │
│                                     │
│ ┌─────────────────┐ ┌─────────────┐ │
│ │ AADConnectDsc   │ │ ADSync      │ │
│ │ Module          │ │ Service     │ │
│ └─────────────────┘ └─────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Synchronization Engine          │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### High Availability Deployment

```
┌─────────────────┐    ┌─────────────────┐
│ Primary AAD     │    │ Staging AAD     │
│ Connect Server  │    │ Connect Server  │
│                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │DSC Config   │ │    │ │DSC Config   │ │
│ │(Active)     │ │    │ │(Staging)    │ │
│ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘
           │                     │
           └─────────┬───────────┘
                     │
           ┌─────────▼─────────┐
           │    Azure AD       │
           └───────────────────┘
```

## Extensibility Points

### Custom Resources

Developers can extend the module by creating additional DSC resources:

```powershell
[DscResource()]
class CustomSyncResource : AADConnectDscBase {
    [DscProperty(Key)]
    [string] $Name
    
    [CustomSyncResource] Get() {
        # Implementation
    }
    
    [bool] Test() {
        # Implementation  
    }
    
    [void] Set() {
        # Implementation
    }
}
```

### Plugin Architecture

Future versions may support plugins for:

- **Custom Attribute Flow**: Complex transformation logic
- **External Data Sources**: Integration with HR systems
- **Compliance Reporting**: Automated compliance checks
- **Monitoring Integration**: Health monitoring and alerting

## Best Practices

### Configuration Design

1. **Idempotency**: All operations must be idempotent
2. **Atomic Changes**: Group related changes in single configurations
3. **Validation First**: Use Test-DSCConfiguration before applying
4. **Backup Strategy**: Always backup before major changes

### Production Deployment

1. **Staging Environment**: Test all changes in staging first
2. **Change Windows**: Apply changes during maintenance windows
3. **Monitoring**: Monitor synchronization health post-deployment
4. **Rollback Plan**: Maintain rollback procedures for all changes
