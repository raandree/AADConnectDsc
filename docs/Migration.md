# Migration Guide

## Overview

This guide provides step-by-step instructions for migrating from manual Azure AD Connect configurations to declarative DSC management using AADConnectDsc.

## Pre-Migration Assessment

### Current State Analysis

Before beginning migration, document your existing configuration.

#### Inventory Existing Sync Rules

```powershell
# Export current sync rules
$existingRules = Get-ADSyncRule
$existingRules | Select-Object Name, Direction, Precedence, Disabled |
    Export-Csv -Path "CurrentSyncRules.csv" -NoTypeInformation

# Identify custom rules (non-Microsoft)
$customRules = $existingRules | Where-Object { 
    $_.Name -notlike "In from AD*" -and 
    $_.Name -notlike "Out to*" -and
    $_.Name -notlike "In from AAD*"
}

Write-Host "Found $($customRules.Count) custom sync rules to migrate"
```

#### Document Directory Extensions

```powershell
# Export directory extension attributes
$extensions = Get-AADConnectDirectoryExtensionAttribute
$extensions | Select-Object Name, AssignedObjectClass, Type, IsEnabled |
    Export-Csv -Path "CurrentExtensions.csv" -NoTypeInformation

Write-Host "Found $($extensions.Count) directory extensions"
```

#### Capture Configuration Dependencies

```powershell
# Document connector information
Get-ADSyncConnector | Select-Object Name, ConnectorTypeName, Version |
    Export-Csv -Path "Connectors.csv" -NoTypeInformation

# Export metaverse schema
Get-ADSyncSchema | Select-Object ConnectorName, ObjectTypeName, AttributeName |
    Export-Csv -Path "Schema.csv" -NoTypeInformation
```

### Environment Preparation

#### Backup Current Configuration

**Critical**: Always create comprehensive backups before migration.

```powershell
# Create backup directory
$backupPath = "C:\AADConnectBackup\$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -Path $backupPath -ItemType Directory -Force

# Export all sync rules
$allRules = Get-ADSyncRule
$allRules | Export-Clixml -Path "$backupPath\AllSyncRules.xml"

# Export directory extensions
$allExtensions = Get-AADConnectDirectoryExtensionAttribute
$allExtensions | Export-Clixml -Path "$backupPath\DirectoryExtensions.xml"

# Export connector configuration
Get-ADSyncConnector | Export-Clixml -Path "$backupPath\Connectors.xml"

Write-Host "Backup completed: $backupPath"
```

#### Install AADConnectDsc Module

```powershell
# Install from PowerShell Gallery
Install-Module AADConnectDsc -Force -AllowClobber

# Verify installation
Get-Module AADConnectDsc -ListAvailable
Import-Module AADConnectDsc -Force
```

#### Validate Prerequisites

```powershell
# Check PowerShell version - MUST be Windows PowerShell 5.1
if ($PSVersionTable.PSVersion.Major -lt 5 -or $PSVersionTable.PSVersion.Minor -lt 1) {
    throw "PowerShell 5.1 or higher required"
}

# Ensure you're NOT running PowerShell 7
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    throw "AADConnectDsc requires Windows PowerShell 5.1, not PowerShell 7"
}

# Verify ADSync module
if (-not (Get-Module ADSync -ListAvailable)) {
    throw "ADSync module not found. Ensure Azure AD Connect is installed."
}

# Check service status
if ((Get-Service ADSync).Status -ne 'Running') {
    Write-Warning "Azure AD Connect service is not running"
}
```

## Migration Strategies

### Strategy 1: Parallel Deployment

Deploy DSC alongside existing configuration, then gradually transition.

**Advantages**:

- Low risk approach
- Easy rollback
- Gradual validation

**Process**:

1. **Create DSC configurations** for new sync rules with different names
2. **Test thoroughly** in staging environment
3. **Deploy to production** alongside existing rules
4. **Validate behavior** with limited scope
5. **Gradually replace** existing rules
6. **Remove old rules** after validation

**Example**:

```powershell
Configuration ParallelDeployment
{
    Import-DscResource -ModuleName AADConnectDsc
    
    Node localhost
    {
        # New DSC-managed rule alongside existing
        AADSyncRule 'DSC_UserSyncRule'
        {
            Name               = 'DSC - Inbound - User - Standard'
            ConnectorName      = 'contoso.com'
            Direction          = 'Inbound'
            TargetObjectType   = 'person'
            SourceObjectType   = 'user'
            LinkType           = 'Join'
            Precedence         = 150  # Different from existing
            Disabled           = $true # Start disabled for testing
            
            # Mirror existing rule configuration
            ScopeConditionGroups = @(
                # ... copy from existing rule
            )
        }
    }
}
```

### Strategy 2: Direct Replacement

Replace existing configuration directly with DSC equivalents.

**Advantages**:

- Clean migration
- No duplicate rules
- Immediate DSC management

**Risks**:

- Higher risk of disruption
- Requires thorough testing
- More complex rollback

**Process**:

1. **Document existing rules** completely
2. **Create exact DSC equivalents**
3. **Test extensively** in staging
4. **Schedule maintenance window**
5. **Remove existing rules**
6. **Apply DSC configuration**
7. **Validate immediately**

### Strategy 3: Hybrid Approach

Migrate some rules to DSC while keeping others manual.

**Use Cases**:

- Complex rules that need gradual migration
- Rules that change frequently (keep manual)
- Standard rules (migrate to DSC)

## Step-by-Step Migration Process

### Phase 1: Directory Extensions Migration

Migrate directory extension attributes first as they're dependencies for sync rules.

#### Step 1: Document Current Extensions

```powershell
# Get detailed extension information
$extensions = Get-AADConnectDirectoryExtensionAttribute
foreach ($ext in $extensions) {
    Write-Host "Extension: $($ext.Name)"
    Write-Host "  Object Class: $($ext.AssignedObjectClass)"
    Write-Host "  Type: $($ext.Type)"
    Write-Host "  Enabled: $($ext.IsEnabled)"
    Write-Host ""
}
```

#### Step 2: Create DSC Configuration

```powershell
Configuration DirectoryExtensions
{
    Import-DscResource -ModuleName AADConnectDsc
    
    Node localhost
    {
        AADConnectDirectoryExtensionAttribute 'EmployeeID'
        {
            Name                = 'employeeID'
            AssignedObjectClass = 'user'
            Type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
        
        AADConnectDirectoryExtensionAttribute 'CostCenter'
        {
            Name                = 'costCenter'
            AssignedObjectClass = 'user'
            Type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
    }
}
```

#### Step 3: Apply and Validate

```powershell
# Compile configuration
DirectoryExtensions -OutputPath .\DirectoryExtensions

# Test configuration
Test-DscConfiguration -Path .\DirectoryExtensions

# Apply configuration
Start-DscConfiguration -Path .\DirectoryExtensions -Wait -Verbose

# Validate results
Get-AADConnectDirectoryExtensionAttribute | Format-Table
```

### Phase 2: Simple Sync Rules Migration

Start with simple sync rules that have minimal dependencies.

#### Step 1: Identify Simple Rules

```powershell
# Find rules with basic scope and attribute flow
$simpleRules = Get-ADSyncRule | Where-Object {
    $_.ScopeFilter.Groups.Count -le 1 -and
    $_.AttributeFlowMappings.Count -le 5 -and
    $_.Name -like "*Custom*"
}

$simpleRules | Select-Object Name, Direction, Precedence
```

#### Step 2: Convert to DSC

For each simple rule, create a DSC equivalent:

```powershell
# Example conversion
$existingRule = Get-ADSyncRule -Name "Custom - Inbound - User - Basic"

# Create DSC configuration
AADSyncRule 'BasicUserRule'
{
    Name               = $existingRule.Name
    ConnectorName      = $existingRule.ConnectorName
    Direction          = $existingRule.Direction
    TargetObjectType   = $existingRule.TargetObjectType
    SourceObjectType   = $existingRule.SourceObjectType
    LinkType           = $existingRule.LinkType
    Precedence         = $existingRule.Precedence
    Description        = $existingRule.Description
    
    # Convert scope filters
    ScopeConditionGroups = @(
        @{
            ScopeConditions = @(
                @{
                    Attribute = 'cloudFiltered'
                    Operator = 'EQUAL'
                    Value = 'False'
                }
            )
        }
    )
    
    # Convert attribute flows
    AttributeFlowMappings = @(
        @{
            Source = 'givenName'
            Destination = 'firstName'
            FlowType = 'Direct'
        },
        @{
            Source = 'sn'
            Destination = 'lastName'
            FlowType = 'Direct'
        }
    )
}
```

### Phase 3: Complex Sync Rules Migration

Migrate complex rules with multiple conditions and flows.

#### Step 1: Analyze Complex Rules

```powershell
$complexRule = Get-ADSyncRule -Name "Complex Custom Rule"

# Examine scope filter structure
$complexRule.ScopeFilter.Groups | ForEach-Object {
    Write-Host "Scope Group:"
    $_.Conditions | ForEach-Object {
        Write-Host "  $($_.Attribute) $($_.Operator) '$($_.Value)'"
    }
}

# Examine join conditions
$complexRule.JoinFilter.Groups | ForEach-Object {
    Write-Host "Join Group:"
    $_.Conditions | ForEach-Object {
        Write-Host "  CS: $($_.CsAttribute) -> MV: $($_.MvAttribute)"
    }
}

# Examine attribute flows
$complexRule.AttributeFlowMappings | ForEach-Object {
    Write-Host "Flow: $($_.Source) -> $($_.Destination) ($($_.FlowType))"
}
```

#### Step 2: Build Complex DSC Configuration

```powershell
Configuration ComplexMigration
{
    Import-DscResource -ModuleName AADConnectDsc
    
    Node localhost
    {
        AADSyncRule 'ComplexUserRule'
        {
            Name               = 'Custom - Inbound - User - Complex'
            ConnectorName      = 'contoso.com'
            Direction          = 'Inbound'
            TargetObjectType   = 'person'
            SourceObjectType   = 'user'
            LinkType           = 'Join'
            Precedence         = 75
            
            # Multiple scope condition groups (OR logic)
            ScopeConditionGroups = @(
                @{
                    # Employees in specific OUs
                    ScopeConditions = @(
                        @{
                            Attribute = 'employeeType'
                            Operator = 'EQUAL'
                            Value = 'Employee'
                        },
                        @{
                            Attribute = 'dn'
                            Operator = 'CONTAINS'
                            Value = 'OU=Employees'
                        }
                    )
                },
                @{
                    # Contractors with specific attributes
                    ScopeConditions = @(
                        @{
                            Attribute = 'employeeType'
                            Operator = 'EQUAL'
                            Value = 'Contractor'
                        },
                        @{
                            Attribute = 'extensionAttribute1'
                            Operator = 'ISNOTNULL'
                            Value = $null
                        }
                    )
                }
            )
            
            # Complex join conditions
            JoinConditionGroups = @(
                @{
                    JoinConditions = @(
                        @{
                            CsAttribute = 'mail'
                            MvAttribute = 'mail'
                            CaseSensitive = $false
                        },
                        @{
                            CsAttribute = 'employeeID'
                            MvAttribute = 'extension_employeeID'
                            CaseSensitive = $false
                        }
                    )
                }
            )
            
            # Multiple attribute flows
            AttributeFlowMappings = @(
                @{
                    Source = 'givenName'
                    Destination = 'firstName'
                    FlowType = 'Direct'
                },
                @{
                    Source = 'sn'
                    Destination = 'lastName'
                    FlowType = 'Direct'
                },
                @{
                    Source = 'employeeNumber'
                    Destination = 'extension_employeeID'
                    FlowType = 'Direct'
                    ExecuteOnce = $true
                },
                @{
                    Source = 'department'
                    Destination = 'extension_costCenter'
                    FlowType = 'Direct'
                }
            )
        }
    }
}
```

### Phase 4: Validation and Cleanup

#### Step 1: Comprehensive Testing

```powershell
# Test all configurations
Test-DscConfiguration -Path .\ComplexMigration

# Apply in test mode first
Start-DscConfiguration -Path .\ComplexMigration -WhatIf

# Monitor sync results
Get-ADSyncConnectorRunStatus
```

#### Step 2: Remove Old Rules

After validation, remove the manually created rules:

```powershell
# List rules to remove (careful!)
$rulesToRemove = Get-ADSyncRule | Where-Object {
    $_.Name -like "*Custom*" -and
    $_.Name -notlike "*DSC*"  # Don't remove DSC-managed rules
}

# Remove old rules (be very careful!)
foreach ($rule in $rulesToRemove) {
    Write-Host "Removing rule: $($rule.Name)"
    Remove-ADSyncRule -SyncRule $rule -Force
}
```

#### Step 3: Final Validation

```powershell
# Verify only DSC-managed rules remain
Get-ADSyncRule | Where-Object Name -like "*Custom*" | 
    Select-Object Name, Direction, Precedence

# Test DSC compliance
Test-DscConfiguration -Detailed
```

## Migration Best Practices

### Testing Strategy

1. **Staging Environment**: Always test in staging first
2. **Limited Scope**: Start with test OUs or limited user sets
3. **Gradual Rollout**: Migrate in phases, not all at once
4. **Validation Points**: Define specific validation criteria
5. **Rollback Plan**: Have tested rollback procedures ready

### Risk Mitigation

1. **Comprehensive Backups**: Multiple backup layers
2. **Change Windows**: Perform during low-impact times
3. **Expert Resources**: Have knowledgeable team members available
4. **Communication**: Inform stakeholders of changes
5. **Monitoring**: Enhanced monitoring during migration

### Common Migration Pitfalls

#### Scope Filter Conversion Errors

**Problem**: Incorrectly converting scope filter logic

**Solution**: Map each condition carefully and test with known objects

#### Precedence Conflicts

**Problem**: New DSC rules conflict with existing rules

**Solution**: Use unique precedence values and plan precedence strategy

#### Attribute Flow Issues

**Problem**: Complex expressions not properly converted

**Solution**: Document and test each attribute flow mapping

#### Dependency Management

**Problem**: Rules applied in wrong order due to missing dependencies

**Solution**: Use DependsOn properly in DSC configurations

## Post-Migration Activities

### Documentation Updates

1. Update operational procedures
2. Create new troubleshooting guides
3. Train operational staff on DSC management
4. Document configuration management processes

### Monitoring and Maintenance

1. Implement DSC compliance monitoring
2. Set up automated configuration drift detection
3. Establish regular configuration reviews
4. Plan for ongoing maintenance and updates

### Continuous Improvement

1. Review migration lessons learned
2. Optimize DSC configurations based on performance
3. Expand DSC usage to additional sync rules
4. Consider automation for future changes

## Rollback Procedures

### Emergency Rollback

If critical issues occur during migration:

```powershell
# Stop Azure AD Connect sync
Stop-Service ADSync

# Remove DSC-created rules
Get-ADSyncRule | Where-Object Name -like "*DSC*" | 
    ForEach-Object { Remove-ADSyncRule -SyncRule $_ -Force }

# Restore from backup
$backup = Import-Clixml -Path "C:\AADConnectBackup\20231201\AllSyncRules.xml"
foreach ($rule in $backup) {
    # Restore rule (implementation depends on ADSync module capabilities)
    New-ADSyncRule -SyncRule $rule
}

# Start service
Start-Service ADSync
```

### Planned Rollback

For controlled rollback after testing:

1. Document reasons for rollback
2. Remove DSC configurations
3. Restore previous manual configurations
4. Validate sync functionality
5. Update documentation

## Success Criteria

### Technical Success Indicators

- All sync rules managed through DSC
- No synchronization errors or warnings
- Performance maintained or improved
- Configuration drift detection working
- Backup and restore procedures validated

### Operational Success Indicators

- Staff trained on DSC management
- Documentation updated and accessible
- Change management processes adapted
- Monitoring and alerting configured
- Troubleshooting procedures tested

### Business Success Indicators

- User experience unchanged or improved
- Compliance requirements met
- Reduced operational overhead
- Improved configuration consistency
- Enhanced disaster recovery capabilities
