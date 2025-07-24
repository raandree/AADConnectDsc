# System Patterns: AADConnectDsc Architecture

## Architecture Overview

AADConnectDsc implements a layered architecture that follows PowerShell DSC
community standards while integrating seamlessly with Azure AD Connect's
existing PowerShell modules.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Configuration Management Layer               │
│  (External systems like AADConnectConfig, Azure Automation)    │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AADConnectDsc Module                      │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐  │
│  │   DSC Classes   │ │ Public Functions│ │Private Functions│  │
│  │ - AADSyncRule   │ │ - Get-ADSyncRule│ │ - New-Guid2     │  │
│  │ - AADConnectDir │ │ - Add-AADConnect│ │ - Convert-Object│  │
│  │   ExtensionAttr │ │   DirExtensionAtr│ │   ToHashtable   │  │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘  │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Azure AD Connect Layer                      │
│              (ADSync PowerShell Module)                        │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Azure AD Connect Service                     │
│            (Synchronization Engine & Database)                 │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### DSC Resource Classes

#### AADSyncRule Class

The core DSC resource for managing synchronization rules:

**Key Responsibilities:**
- Validate sync rule configuration
- Manage rule creation, modification, and deletion
- Handle complex property types (scope filters, join conditions, attribute flows)
- Integrate with Azure AD Connect precedence system
- Support both standard and custom rules with differentiated behavior

**Design Patterns:**
- **State Management**: Get/Test/Set pattern for DSC compliance
- **Property Validation**: Strong typing with custom validation
- **Error Handling**: Comprehensive error reporting with context
- **Logging**: Verbose logging for troubleshooting
- **Standard Rule Handling**: Specialized logic for Microsoft standard rules

**Standard Rule Behavior Pattern:**
```powershell
# For IsStandardRule = $true:
# - Only Name and Disabled properties are evaluated for DSC compliance
# - All other properties are excluded from Test() comparison
# - Secondary comparison performed for informational purposes
# - Only Disabled property can be modified via Set()
```

**Class Hierarchy:**
```powershell
AADSyncRule
├── Properties (DscProperty attributes)
│   ├── Key Properties: Name, ConnectorName
│   ├── Mandatory Properties: TargetObjectType, SourceObjectType, Direction, LinkType
│   ├── Complex Properties: ScopeFilter, JoinFilter, AttributeFlowMappings
│   └── System Properties: Identifier, Version (NotConfigurable)
├── Methods
│   ├── Get() → Current state retrieval
│   ├── Test() → Configuration compliance check (with standard rule logic)
│   └── Set() → Configuration application (limited for standard rules)
└── Helper Classes
    ├── ScopeConditionGroup/ScopeCondition
    ├── JoinConditionGroup/JoinCondition
    └── AttributeFlowMapping
```

#### AADConnectDirectoryExtensionAttribute Class

Manages directory schema extensions:

**Responsibilities:**
- Directory extension attribute lifecycle management
- Schema validation and registration
- Integration with Azure AD schema requirements

### Public Function Layer

#### Get-ADSyncRule Function

Enhanced wrapper around the native ADSync module:

**Design Pattern**: Parameter Set Pattern
```powershell
Parameter Sets:
├── ByName (default)
├── ByIdentifier  
├── ByConnector
└── ByNameAndConnector
```

**Enhancements over native cmdlet:**
- Simplified connector name resolution
- Better error handling and validation
- Consistent return object format
- Support for common filtering scenarios

#### Directory Extension Functions

Three-function pattern for CRUD operations:
- `Add-AADConnectDirectoryExtensionAttribute`
- `Get-AADConnectDirectoryExtensionAttribute`  
- `Remove-AADConnectDirectoryExtensionAttribute`

### Integration Patterns

#### Azure AD Connect SDK Integration

**Pattern**: Wrapper with Enhancement
- Leverages existing ADSync module functionality
- Adds validation and error handling
- Provides simplified interfaces for common operations
- Maintains compatibility with native cmdlets

#### DSC Framework Integration

**Pattern**: Class-Based Resource Implementation
- Follows DSC resource lifecycle (Get/Test/Set)
- Implements proper state management
- Provides idempotent operations
- Supports DSC logging and reporting

#### Error Handling Strategy

**Pattern**: Layered Error Handling
1. **Input Validation**: Parameter validation at entry points
2. **Business Logic Validation**: Validate against Azure AD Connect rules
3. **Integration Errors**: Handle ADSync module failures gracefully
4. **System Errors**: Catch and wrap system-level exceptions

## Data Flow Patterns

### Configuration Application Flow

```
DSC Configuration (MOF)
          │
          ▼
    AADSyncRule.Set()
          │
          ├─── Validate Configuration
          │    ├─── Check Connector Exists
          │    ├─── Validate Scope Filters  
          │    ├─── Validate Join Conditions
          │    └─── Validate Attribute Mappings
          │
          ├─── Determine Required Actions
          │    ├─── New Rule Creation
          │    ├─── Existing Rule Update
          │    └─── Standard Rule Enable/Disable
          │
          └─── Apply Changes
               ├─── Create New-ADSyncRule Objects
               ├─── Configure Scope/Join/Flow Components
               ├─── Set Precedence and Properties
               └─── Apply via Add-ADSyncRule
```

### State Detection Flow

```
AADSyncRule.Get()
     │
     ├─── Query Current Rules
     │    └─── Get-ADSyncRule (enhanced)
     │
     ├─── Transform to DSC Format
     │    ├─── Map ADSync Objects to DSC Properties
     │    ├─── Resolve Connector Names
     │    └─── Convert Complex Objects
     │
     └─── Return Current State Object
```

## Key Design Decisions

### Class-Based Implementation

**Decision**: Use PowerShell classes instead of MOF-based resources

**Rationale:**
- Better performance and memory usage
- Stronger typing and validation
- Easier maintenance and debugging
- Modern PowerShell development practices

### Precedence Management

**Decision**: Automatic precedence assignment for custom rules

**Rationale:**
- Reduces configuration complexity
- Eliminates precedence conflicts
- Follows Azure AD Connect best practices
- Enables sequential rule processing

### Expression Handling

**Decision**: Support for complex attribute flow expressions

**Implementation:**
- String-based expression storage
- Whitespace normalization for comparison
- Support for PowerShell and built-in functions
- Validation against allowed expression patterns

### Connector Resolution

**Decision**: Use connector names instead of GUIDs in configuration

**Benefits:**
- Human-readable configurations
- Environment portability
- Easier troubleshooting
- Reduced configuration errors

## Testing and Validation Patterns

### Standard Rule Comparison Pattern

**Pattern**: Differential Property Evaluation

```powershell
# Primary comparison (affects DSC compliance)
$param.ExcludeProperties = if ($this.IsStandardRule) {
    # Exclude ALL properties except Name and Disabled for standard rules
    ($this | Get-Member -MemberType Property).Name | 
        Where-Object { $_ -notin 'Name', 'Disabled' }
} else {
    # Standard exclusions for custom rules
    'Connector', 'Version', 'Identifier'
}

# Secondary comparison (informational only)
if ($this.IsStandardRule) {
    $param.ExcludeProperties = 'Connector', 'Version', 'Identifier', 'Precedence'
    # Perform comparison but don't affect return value
    $null = Test-DscParameterState @param -ReverseCheck
}
```

**Benefits:**
- Standard rules only fail DSC compliance if Name/Disabled differ
- Secondary comparison provides visibility into configuration drift
- Clear separation between actionable and informational differences
- Prevents false failures for immutable standard rule properties

### Unit Testing Strategy

**Pattern**: Class Method Testing
- Test each DSC method (Get/Test/Set) independently
- Mock Azure AD Connect dependencies
- Validate complex object transformations
- Test error handling scenarios
- Test standard vs custom rule behavior differences

### Integration Testing Strategy

**Pattern**: Live Environment Testing
- Test against actual Azure AD Connect installations
- Validate end-to-end configuration scenarios
- Test upgrade and migration scenarios
- Performance testing with large rule sets

### Validation Framework

**Pattern**: Multi-Layer Validation
1. **Schema Validation**: Ensure configuration meets DSC requirements
2. **Business Rule Validation**: Validate against Azure AD Connect constraints
3. **Integration Validation**: Test actual application to sync engine
4. **State Validation**: Verify desired state achievement

This architecture provides a solid foundation for reliable, maintainable, and
extensible Azure AD Connect configuration management through PowerShell DSC.
