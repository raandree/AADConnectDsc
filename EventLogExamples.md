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

## Key Benefits of Multi-Line Format

1. **Easy Scanning**: Rule name and connector are clearly visible on separate lines
2. **Rich Context**: Direction, object types, and precedence provide operational context
3. **Rule Type Identification**: Clearly distinguishes between Microsoft standard and custom rules
4. **Disabled State Visibility**: Shows current enabled/disabled state for troubleshooting
5. **Precedence Information**: Critical for understanding rule evaluation order
6. **Better Event Viewer Experience**: Easier to read in Windows Event Viewer details pane

## Additional Information Available in Events

The enhanced event logging now includes:
- **Rule Name**: Primary identifier for the sync rule
- **Connector**: Which connector the rule applies to
- **Direction**: Inbound or Outbound synchronization
- **Target/Source Object Types**: What objects the rule affects
- **Precedence**: Rule evaluation priority (lower numbers = higher priority)
- **Disabled State**: Whether the rule is currently active
- **Rule Type**: Microsoft Standard Rule vs Custom Rule

This information enables administrators to:
- Quickly identify which sync rules are experiencing drift
- Understand the business impact of configuration changes
- Prioritize remediation based on rule importance and precedence
- Distinguish between standard Microsoft rules and custom implementations
