# Example of Enhanced Multi-Line Event Log Messages

## What the Event Log Messages Look Like Now

### Event ID 1000 (Information) - Sync Rule in Desired State

```
AADSyncRule is in desired state and compliant with configuration

Sync Rule Details:
  Rule Name: In from AD - User Join
  Connector: contoso.local
  Direction: Inbound
  Target Object Type: person
  Source Object Type: user
  Precedence: 100
  Disabled: False
  Rule Type: Microsoft Standard Rule
```

### Event ID 1001 (Warning) - Sync Rule Missing

```
AADSyncRule is absent but should be present - configuration drift detected

Sync Rule Details:
  Rule Name: Custom User Inbound Rule
  Connector: contoso.local
  Direction: Inbound
  Target Object Type: person
  Source Object Type: user
  Precedence: 150
  Disabled: False
  Rule Type: Custom Rule
```

### Event ID 1002 (Warning) - Sync Rule Should Be Absent

```
AADSyncRule is present but should be absent - configuration drift detected

Sync Rule Details:
  Rule Name: Obsolete User Rule
  Connector: contoso.local
  Direction: Outbound
  Target Object Type: user
  Source Object Type: person
  Precedence: 200
  Disabled: True
  Rule Type: Custom Rule
```

### Event ID 1003 (Warning) - Configuration Drift

```
AADSyncRule configuration drift detected - current state does not match desired state

Sync Rule Details:
  Rule Name: Out to AAD - User Join
  Connector: tenant.onmicrosoft.com - AAD
  Direction: Outbound
  Target Object Type: user
  Source Object Type: person
  Precedence: 50
  Disabled: False
  Rule Type: Microsoft Standard Rule
```

### Event ID 2000 (Information) - Sync Rule Created

```
Sync rule created successfully

Sync Rule Details:
  Rule Name: Custom User Inbound Rule
  Connector: contoso.local
  Direction: Inbound
  Target Object Type: person
  Source Object Type: user
  Precedence: 150
  Disabled: False
  Rule Type: Custom Rule
  Operation: Create
  Rule Identifier: {12345678-1234-1234-1234-123456789abc}
  Scope Filter Groups: 2
  Join Filter Groups: 1
  Attribute Flow Mappings: 5
```

### Event ID 2001 (Information) - Sync Rule Updated

```
Sync rule updated successfully

Sync Rule Details:
  Rule Name: Custom Contact Outbound Rule
  Connector: tenant.onmicrosoft.com - AAD
  Direction: Outbound
  Target Object Type: contact
  Source Object Type: person
  Precedence: 180
  Disabled: False
  Rule Type: Custom Rule
  Operation: Update
  Rule Identifier: {87654321-4321-4321-4321-abcdef123456}
  Scope Filter Groups: 1
  Join Filter Groups: 1
  Attribute Flow Mappings: 3
```

### Event ID 2002 (Information) - Standard Rule State Changed

```
Standard sync rule disabled state changed successfully

Sync Rule Details:
  Rule Name: In from AD - User Join
  Connector: contoso.local
  Direction: Inbound
  Target Object Type: person
  Source Object Type: user
  Precedence: 50
  Disabled: True
  Rule Type: Microsoft Standard Rule
  Operation: Changed Disabled state from False to True
  Rule Identifier: {abcdef12-3456-7890-abcd-ef1234567890}
```

### Event ID 2003 (Information) - Sync Rule Removed

```
Sync rule removed successfully

Sync Rule Details:
  Rule Name: Obsolete Contact Rule
  Connector: contoso.local
  Direction: Inbound
  Target Object Type: contact
  Source Object Type: contact
  Precedence: 999
  Disabled: True
  Rule Type: Custom Rule
  Operation: Remove
  Rule Identifier: {fedcba09-8765-4321-fedc-ba0987654321}
```

## Key Benefits of Multi-Line Format

1. **Easy Scanning**: Rule name and connector are clearly visible on separate lines
2. **Rich Context**: Direction, object types, and precedence provide operational context
3. **Rule Type Identification**: Clearly distinguishes between Microsoft standard and custom rules
4. **Disabled State Visibility**: Shows current enabled/disabled state for troubleshooting
5. **Precedence Information**: Critical for understanding rule evaluation order
6. **Better Event Viewer Experience**: Easier to read in Windows Event Viewer details pane

## Additional Information Available in Events

The enhanced event logging now includes:

### Basic Rule Information

- **Rule Name**: Primary identifier for the sync rule
- **Connector**: Which connector the rule applies to
- **Direction**: Inbound or Outbound synchronization
- **Target/Source Object Types**: What objects the rule affects
- **Precedence**: Rule evaluation priority (lower numbers = higher priority)
- **Disabled State**: Whether the rule is currently active
- **Rule Type**: Microsoft Standard Rule vs Custom Rule

### Operational Details (Set() Operations)

- **Operation**: Type of operation performed (Create, Update, Remove, State Change)
- **Rule Identifier**: Unique GUID identifier for the sync rule
- **Scope Filter Groups**: Number of scope filter condition groups
- **Join Filter Groups**: Number of join condition groups  
- **Attribute Flow Mappings**: Number of attribute flow mappings

This information enables administrators to:

- Quickly identify which sync rules are experiencing drift
- Understand the business impact of configuration changes
- Prioritize remediation based on rule importance and precedence
- Distinguish between standard Microsoft rules and custom implementations
- Track all operational changes with full audit details
- Assess rule complexity through filter and mapping counts
- Monitor rule lifecycle from creation to removal
