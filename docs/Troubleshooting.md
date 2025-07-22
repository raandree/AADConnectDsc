# Troubleshooting Guide

## Common Issues and Solutions

### DSC Configuration Issues

#### Configuration Compilation Errors

**Problem**: DSC configuration fails to compile with class-related errors

```
At line:1 char:1
+ Configuration TestConfig {
+ ~~~~~~~~~~~~~~~~~~~~~~~~~
Unable to load one or more of the requested types. Retrieve the LoaderExceptions property for more information.
```

**Solutions**:

1. **Verify PowerShell Version**:
   ```powershell
   $PSVersionTable.PSVersion
   # Should be 5.0 or higher
   ```

2. **Check Module Import**:
   ```powershell
   Import-Module AADConnectDsc -Force -Verbose
   ```

3. **Validate Class Loading**:
   ```powershell
   [AADSyncRule]::new()
   ```

#### Resource Property Validation Errors

**Problem**: Properties fail validation during configuration compilation

```
Exception calling "ValidateConfigurationArgument" with "2" argument(s): 
"The property 'Direction' cannot be found on this object."
```

**Solutions**:

1. **Check Property Names**: Ensure exact case matching
   ```powershell
   # Correct
   Direction = 'Inbound'
   
   # Incorrect  
   direction = 'Inbound'
   ```

2. **Validate Enum Values**:
   ```powershell
   # Check valid values for Direction
   [System.Enum]::GetNames([DirectionType])
   ```

3. **Use Tab Completion**: Use ISE or VS Code for property discovery

### Azure AD Connect Integration Issues

#### ADSync Module Not Found

**Problem**: AADConnectDsc cannot find the ADSync module

```
The specified module 'ADSync' was not loaded because no valid module file 
was found in any module directory.
```

**Solutions**:

1. **Verify Azure AD Connect Installation**:
   ```powershell
   Test-Path "C:\Program Files\Microsoft Azure AD Sync\Bin\"
   ```

2. **Import ADSync Module Manually**:
   ```powershell
   Import-Module "C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1"
   ```

3. **Check Module Path**:
   ```powershell
   $env:PSModulePath -split ';'
   # Should include ADSync installation path
   ```

#### Insufficient Permissions

**Problem**: Access denied when attempting to modify sync rules

```
Access to the path 'C:\Program Files\Microsoft Azure AD Sync\Data' is denied.
```

**Solutions**:

1. **Run as Administrator**: Execute PowerShell as local administrator

2. **Check Service Account**: Verify Azure AD Connect service account permissions

3. **Validate User Rights**:
   ```powershell
   whoami /priv
   # Look for SeBackupPrivilege and SeRestorePrivilege
   ```

### Synchronization Engine Issues

#### Service Dependency Problems

**Problem**: Synchronization service is not running

**Solutions**:

1. **Check Service Status**:
   ```powershell
   Get-Service ADSync
   ```

2. **Start Service if Stopped**:
   ```powershell
   Start-Service ADSync
   ```

3. **Check Dependencies**:
   ```powershell
   Get-Service ADSync | Select-Object -ExpandProperty DependentServices
   ```

#### Database Connectivity Issues

**Problem**: Cannot connect to synchronization database

**Solutions**:

1. **Verify LocalDB Instance**:
   ```powershell
   sqllocaldb info
   sqllocaldb info ADSync2019
   ```

2. **Check Database Files**:
   ```powershell
   Test-Path "C:\Program Files\Microsoft Azure AD Sync\Data\ADSync.mdf"
   ```

3. **Restart Database Service**:
   ```powershell
   sqllocaldb stop ADSync2019
   sqllocaldb start ADSync2019
   ```

### Sync Rule Configuration Issues

#### Rule Precedence Conflicts

**Problem**: Multiple rules with same precedence causing conflicts

**Solutions**:

1. **Check Existing Rules**:
   ```powershell
   Get-ADSyncRule | Where-Object Precedence -eq 50 | 
       Select-Object Name, Direction, Precedence
   ```

2. **Use Unique Precedence Values**:
   ```powershell
   # Find next available precedence
   $maxPrecedence = (Get-ADSyncRule | Measure-Object Precedence -Maximum).Maximum
   $newPrecedence = $maxPrecedence + 1
   ```

3. **Update Conflicting Rules**:
   ```powershell
   AADSyncRule 'MyRule'
   {
       Precedence = $newPrecedence
       # ... other properties
   }
   ```

#### Scope Filter Issues

**Problem**: Sync rule not applying to expected objects

**Solutions**:

1. **Validate Scope Conditions**:
   ```powershell
   # Test scope condition logic
   $testUser = Get-ADUser testuser -Properties *
   $testUser.cloudFiltered -eq 'False'
   ```

2. **Check Attribute Availability**:
   ```powershell
   Get-ADUser testuser -Properties * | Get-Member -Name cloudFiltered
   ```

3. **Debug with Simple Scope**:
   ```powershell
   ScopeConditionGroups = @(
       @{
           ScopeConditions = @(
               @{
                   Attribute = 'objectClass'
                   Operator = 'EQUAL'
                   Value = 'user'
               }
           )
       }
   )
   ```

#### Join Condition Failures

**Problem**: Objects not joining correctly between namespaces

**Solutions**:

1. **Verify Attribute Values**:
   ```powershell
   # Check connector space attribute
   $csObject | Select-Object mail
   
   # Check metaverse attribute
   $mvObject | Select-Object mail
   ```

2. **Test Case Sensitivity**:
   ```powershell
   JoinConditionGroups = @(
       @{
           JoinConditions = @(
               @{
                   CsAttribute = 'mail'
                   MvAttribute = 'mail'
                   CaseSensitive = $false  # Try both true and false
               }
           )
       }
   )
   ```

3. **Use Multiple Join Conditions**:
   ```powershell
   JoinConditions = @(
       @{
           CsAttribute = 'mail'
           MvAttribute = 'mail'
           CaseSensitive = $false
       },
       @{
           CsAttribute = 'userPrincipalName'
           MvAttribute = 'userPrincipalName'  
           CaseSensitive = $false
       }
   )
   ```

### Directory Extension Issues

#### Schema Extension Failures

**Problem**: Directory extension attribute creation fails

**Solutions**:

1. **Check Existing Attributes**:
   ```powershell
   Get-AADConnectDirectoryExtensionAttribute | 
       Where-Object Name -eq 'employeeID'
   ```

2. **Verify Object Class**:
   ```powershell
   # Valid object classes
   @('user', 'group', 'contact') -contains 'user'
   ```

3. **Validate Data Type**:
   ```powershell
   # Valid data types
   @('String', 'Integer', 'DateTime', 'Boolean', 'Binary') -contains 'String'
   ```

#### Attribute Reference Issues

**Problem**: Sync rules cannot reference extension attributes

**Solutions**:

1. **Use Correct Attribute Name**:
   ```powershell
   AttributeFlowMappings = @(
       @{
           Source = 'employeeNumber'
           Destination = 'extension_employeeID'  # Note the prefix
           FlowType = 'Direct'
       }
   )
   ```

2. **Verify Attribute Exists**:
   ```powershell
   Get-AADConnectDirectoryExtensionAttribute -Name 'employeeID'
   ```

3. **Check Attribute State**:
   ```powershell
   $attr = Get-AADConnectDirectoryExtensionAttribute -Name 'employeeID'
   $attr.IsEnabled  # Should be True
   ```

## Diagnostic Commands

### System Health Checks

```powershell
# Check PowerShell version
$PSVersionTable

# Verify module installation
Get-Module AADConnectDsc -ListAvailable

# Check ADSync module
Get-Module ADSync -ListAvailable

# Verify Azure AD Connect service
Get-Service ADSync

# Check synchronization database
Test-Path "C:\Program Files\Microsoft Azure AD Sync\Data\ADSync.mdf"
```

### Configuration Validation

```powershell
# Test DSC configuration syntax
Test-DscConfiguration -Path .\MyConfig.ps1

# Validate specific resource
$resource = [AADSyncRule]::new()
$resource.Name = 'Test Rule'
# Set other required properties...
$resource.Test()

# Check current sync rules
Get-ADSyncRule | Format-Table Name, Direction, Precedence, Disabled
```

### Troubleshooting Workflows

#### New Sync Rule Issues

1. **Validate Configuration**:
   ```powershell
   Test-DscConfiguration -Path .\SyncRuleConfig.ps1
   ```

2. **Check Prerequisites**:
   ```powershell
   # Verify connector exists
   Get-ADSyncConnector -Name 'contoso.com'
   
   # Check target object type
   Get-ADSyncSchema -ConnectorName 'contoso.com' | 
       Where-Object ObjectType -eq 'user'
   ```

3. **Apply Configuration**:
   ```powershell
   Start-DscConfiguration -Path .\SyncRuleConfig -Wait -Verbose
   ```

4. **Verify Results**:
   ```powershell
   Get-ADSyncRule -Name 'My Custom Rule'
   ```

#### Directory Extension Issues

1. **Check Current State**:
   ```powershell
   Get-AADConnectDirectoryExtensionAttribute -Name 'myAttribute'
   ```

2. **Validate Prerequisites**:
   ```powershell
   # Check if attribute name conflicts with existing
   Get-ADObject -SearchBase (Get-ADRootDSE).schemaNamingContext -Filter {name -eq 'myAttribute'}
   ```

3. **Apply Configuration**:
   ```powershell
   Start-DscConfiguration -Path .\ExtensionConfig -Wait -Verbose
   ```

4. **Test Attribute Usage**:
   ```powershell
   # Create test sync rule using the extension
   AADSyncRule 'TestExtensionRule'
   {
       # ... configuration using extension_myAttribute
   }
   ```

## Performance Troubleshooting

### Slow Configuration Application

**Symptoms**: DSC configuration takes excessive time to apply

**Solutions**:

1. **Check Resource Dependencies**:
   ```powershell
   # Ensure proper DependsOn declarations
   AADSyncRule 'Rule2'
   {
       DependsOn = '[AADSyncRule]Rule1'
       # ... configuration
   }
   ```

2. **Monitor Resource Usage**:
   ```powershell
   Get-Process ADSync
   Get-Counter "\Process(miiserver)\% Processor Time"
   ```

3. **Optimize Queries**:
   ```powershell
   # Use specific filters instead of broad searches
   Get-ADSyncRule -Name 'Specific Rule Name'  # Good
   Get-ADSyncRule | Where-Object Name -like '*Rule*'  # Slower
   ```

### Memory Issues

**Symptoms**: High memory usage during configuration

**Solutions**:

1. **Monitor Memory Usage**:
   ```powershell
   Get-Process PowerShell | Select-Object WorkingSet, VirtualMemorySize
   ```

2. **Clear Variables**:
   ```powershell
   # Clear large variables when done
   Remove-Variable -Name largeVariable
   [System.GC]::Collect()
   ```

3. **Process Resources in Batches**:
   ```powershell
   # Apply configurations in smaller batches instead of all at once
   ```

## Logging and Monitoring

### Enable Detailed Logging

```powershell
# Enable DSC verbose logging
$env:DSCVerbosePreference = 'Continue'

# Enable ADSync module logging
Set-ADSyncAADCompanyFeature -EnableVerboseLogging $true
```

### Log File Locations

- **DSC Logs**: `C:\Windows\System32\Configuration\ConfigurationStatus`
- **Azure AD Connect Logs**: `C:\ProgramData\AADConnect\`
- **Event Logs**: Windows Event Log > Applications and Services > AD FS

### Monitoring Commands

```powershell
# Check recent DSC events
Get-WinEvent -LogName Microsoft-Windows-DSC/Operational -MaxEvents 50

# Monitor Azure AD Connect sync
Get-ADSyncConnectorRunStatus

# Check for errors
Get-EventLog -LogName Application -Source "Directory Synchronization" -EntryType Error
```

## Getting Additional Help

### Community Resources

- **PowerShell DSC Community**: GitHub discussions and issues
- **Azure AD Connect Forums**: Microsoft Tech Community
- **Stack Overflow**: Tagged with `azure-ad-connect` and `powershell-dsc`

### Microsoft Support

- **Azure Support**: For Azure AD Connect service issues
- **PowerShell Support**: For DSC framework issues
- **Premier Support**: For enterprise deployment assistance

### Documentation References

- [PowerShell DSC Documentation](https://docs.microsoft.com/powershell/scripting/dsc/)
- [Azure AD Connect Documentation](https://docs.microsoft.com/azure/active-directory/hybrid/)
- [AADConnectDsc Wiki](link-to-wiki)
