# Technical Context: AADConnectDsc Development

## Technology Stack

### Core Technologies

**PowerShell 5.0+**
- Minimum requirement for class-based DSC resources
- Leverages advanced PowerShell features
- Compatible with Windows PowerShell and PowerShell Core

**PowerShell DSC Framework**
- Native Windows configuration management platform
- Declarative configuration model
- Built-in state management and drift detection

**Azure AD Connect SDK**
- ADSync PowerShell module integration
- Microsoft.Azure.ActiveDirectory.Synchronization.Framework.dll
- Native Azure AD Connect API access

### Dependencies

#### Runtime Dependencies

**Required Modules:**
- `ADSync` - Azure AD Connect PowerShell module (installed with Azure AD Connect)
- `PSDesiredStateConfiguration` - DSC framework (built into Windows PowerShell)

**System Requirements:**
- Windows Server 2012 R2 or later
- PowerShell 5.0 or later
- .NET Framework 4.6 or later (Azure AD Connect requirement)
- Azure AD Connect installed and configured

#### Development Dependencies

**Build Tools:**
- `InvokeBuild` - PowerShell build automation
- `Pester` - PowerShell testing framework
- `PSScriptAnalyzer` - Code quality analysis
- `DscResource.Test` - DSC resource validation

**Documentation Tools:**
- `DscResource.DocGenerator` - Auto-documentation generation
- `Markdown` - Documentation format
- `Git` - Version control

### Module Structure

#### Directory Layout

```
AADConnectDsc/
├── source/                          # Source code
│   ├── AADConnectDsc.psd1          # Module manifest
│   ├── AADConnectDsc.psm1          # Main module file
│   ├── Init.psm1                   # Initialization logic
│   ├── Prefix.ps1                  # Module prefix script
│   │
│   ├── Classes/                    # DSC Resource classes
│   │   ├── AADSyncRule.ps1
│   │   ├── AADConnectDirectoryExtensionAttribute.ps1
│   │   ├── AttributeFlowMapping.ps1
│   │   ├── JoinCondition.ps1
│   │   ├── JoinConditionGroup.ps1
│   │   ├── ScopeCondition.ps1
│   │   └── ScopeConditionGroup.ps1
│   │
│   ├── Public/                     # Public functions
│   │   ├── Get-ADSyncRule.ps1
│   │   ├── Add-AADConnectDirectoryExtensionAttribute.ps1
│   │   ├── Get-AADConnectDirectoryExtensionAttribute.ps1
│   │   ├── Remove-AADConnectDirectoryExtensionAttribute.ps1
│   │   └── Convert-ObjectToHashtable.ps1
│   │
│   ├── Private/                    # Internal functions
│   │   └── New-Guid2.ps1
│   │
│   ├── Enum/                      # Enumeration definitions
│   │   ├── Ensure.ps1
│   │   ├── AttributeMappingFlowType.ps1
│   │   ├── AttributeValueMergeType.ps1
│   │   └── ComparisonOperator.ps1
│   │
│   └── en-US/                     # Help files
│       └── about_AADConnectDsc.help.txt
│
├── tests/                         # Test files
│   ├── QA/                        # Quality assurance tests (current)
│   │   └── module.tests.ps1       # Module validation and PSScriptAnalyzer
│   ├── Unit/                      # Unit tests (planned - not implemented)
│   └── Integration/               # Integration tests (planned - not implemented)
│
├── build.ps1                     # Build script
├── build.yaml                    # Build configuration
├── RequiredModules.psd1          # Build dependencies
└── README.md                     # Documentation
```

### Development Setup

#### Environment Preparation

1. **Install Azure AD Connect**
   - Required for ADSync module availability
   - Provides synchronization engine integration
   - Enables full testing capabilities

2. **PowerShell Configuration**
   - Enable PowerShell script execution
   - Install required development modules
   - Configure development environment variables

3. **Development Tools Setup**
   - Visual Studio Code with PowerShell extension
   - Git for version control
   - Build automation tools

#### Build Process

**Build Pipeline:**
1. **Dependency Resolution**: Download required modules
2. **Code Analysis**: PSScriptAnalyzer validation  
3. **Testing**: Pester test execution
4. **Documentation**: Auto-generate help content
5. **Packaging**: Create module package
6. **Validation**: Final module validation

**Build Configuration:**
```yaml
# build.yaml example structure
ModuleVersion: '0.1'
OutputDirectory: 'output'
TestResultsDirectory: 'tests/results'
RequiredModulesDirectory: 'output/RequiredModules'
```

### Technical Constraints

#### Azure AD Connect Integration

**Constraint: Service Dependency**
- Module requires Azure AD Connect service to be installed
- Cannot function independently of synchronization engine
- Limited to Windows operating systems

**Impact on Design:**
- Must handle service availability checks
- Error handling for missing dependencies  
- Testing requires full Azure AD Connect environment

#### PowerShell DSC Framework

**Constraint: Class-Based Resources**
- Requires PowerShell 5.0+ for class support
- Limited backward compatibility with older PowerShell versions
- Memory and performance considerations

**Impact on Design:**
- Minimum PowerShell version requirements
- Need for compatibility testing across versions
- Performance optimization for large configurations

#### Azure AD Connect API Limitations

**Constraint: PowerShell Module Interface**
- Limited to Microsoft-provided ADSync cmdlets
- No direct API access to synchronization engine
- Dependent on Microsoft's SDK updates

**Impact on Design:**
- Wrapper pattern around existing cmdlets
- Limited to functionality exposed by ADSync module
- Need for version compatibility management

### Security Considerations

#### Credential Management

**Requirements:**
- Secure handling of service account credentials
- Integration with Windows credential management
- Support for encrypted credential storage

**Implementation:**
- Leverage existing Azure AD Connect security model
- No additional credential storage in module
- Rely on Windows security context

#### Privilege Requirements

**Minimum Privileges:**
- Azure AD Connect service account permissions
- Local administrator rights for DSC operations
- Azure AD synchronization permissions

**Security Boundaries:**
- Operate within Azure AD Connect security context
- No elevation of privileges beyond existing requirements
- Audit logging for all configuration changes

### Performance Characteristics

#### Resource Usage

**Memory Footprint:**
- Base module: ~50MB loaded in memory
- DSC operations: Additional 100-200MB during execution
- Scales with number of sync rules managed

**CPU Usage:**
- Low CPU usage during steady state
- Higher usage during configuration application
- Periodic DSC evaluation cycles

**Network Impact:**
- Minimal network traffic (local operations)
- Azure AD Connect handles cloud synchronization
- DSC pull operations if configured

#### Scalability Limits

**Sync Rule Limits:**
- Azure AD Connect supports up to 100 custom sync rules
- Performance degrades with large numbers of rules
- Memory usage scales with rule complexity

**Concurrent Operations:**
- Single-threaded DSC resource execution
- No parallel sync rule processing
- Coordination with Azure AD Connect service required

### Testing Strategy

#### Current Test Implementation

**QA Tests (Implemented)**
- **Location**: `tests/QA/module.tests.ps1`
- **Purpose**: Module quality validation and basic functionality
- **Tests Include**:
  - Changelog format validation
  - Module import/removal testing
  - PSScriptAnalyzer code quality validation
  - Basic module structure verification

**Build Configuration**
- **Framework**: Pester 5.x with NUnit XML output
- **Coverage**: Configured but currently at 0% threshold
- **Test Discovery**: Configured for `tests/Unit` (not yet implemented)
- **CI Integration**: Azure Pipelines with automatic test execution

#### Unit Testing (Planned - Not Implemented)

**Test Scope:**
- Individual function validation (Get-ADSyncRule, Add/Get/Remove-AADConnectDirectoryExtensionAttribute, Convert-ObjectToHashtable)
- Class method testing (AADSyncRule, AADConnectDirectoryExtensionAttribute)
- Parameter validation and boundary testing
- Error handling scenarios and exception paths
- PowerShell help documentation validation

**Required Test Structure:**
```
tests/Unit/
├── Public/
│   ├── Get-ADSyncRule.Tests.ps1
│   ├── Add-AADConnectDirectoryExtensionAttribute.Tests.ps1
│   ├── Get-AADConnectDirectoryExtensionAttribute.Tests.ps1
│   ├── Remove-AADConnectDirectoryExtensionAttribute.Tests.ps1
│   └── Convert-ObjectToHashtable.Tests.ps1
├── Classes/
│   ├── AADSyncRule.Tests.ps1
│   └── AADConnectDirectoryExtensionAttribute.Tests.ps1
└── Private/
    └── New-Guid2.Tests.ps1
```

**Mock Requirements:**
- ADSync module cmdlet mocking (Get-ADSyncRule, Get-ADSyncGlobalSettings, Set-ADSyncGlobalSettings)
- Azure AD Connect service state simulation
- File system and registry mocking for configuration storage
- PowerShell DSC framework interaction mocking

#### Integration Testing (Planned - Not Implemented)

**Test Environment Requirements:**
- Full Azure AD Connect installation with functioning ADSync module
- Test Active Directory domain with sample objects
- Azure AD tenant connectivity for end-to-end validation
- Isolated test environment to prevent production impact
- Dedicated test service account with appropriate permissions

**Test Scenarios:**
- End-to-end DSC configuration application and verification
- Sync rule creation, modification, and deletion workflows
- Directory extension attribute lifecycle management
- Configuration drift detection and remediation
- Error recovery and rollback procedures
- Performance testing with large-scale configurations
- Upgrade and migration scenario validation

**Required Test Structure:**
```
tests/Integration/
├── AADSyncRule.Integration.Tests.ps1
├── AADConnectDirectoryExtensionAttribute.Integration.Tests.ps1
└── CompleteConfiguration.Integration.Tests.ps1
```

#### Testing Gaps and Priorities

**High Priority (Required for Production)**:
1. **Unit Tests for Public Functions** - Critical for reliability
2. **Class Method Unit Tests** - Ensure DSC resource functionality
3. **Mock Framework Setup** - Enable testing without Azure AD Connect dependency
4. **Parameter Validation Tests** - Prevent configuration errors

**Medium Priority (Quality Improvement)**:
1. **Integration Tests** - Full end-to-end validation
2. **Performance Tests** - Large-scale configuration handling
3. **Error Scenario Tests** - Comprehensive error handling validation

**Low Priority (Future Enhancement)**:
1. **Load Testing** - High-volume synchronization scenarios
2. **Compatibility Testing** - Multiple Azure AD Connect versions
3. **Security Testing** - Credential and permission validation

This technical foundation ensures AADConnectDsc can reliably manage Azure AD
Connect configurations while maintaining compatibility with existing
infrastructure and following PowerShell DSC best practices.
