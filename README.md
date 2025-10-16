# AADConnectDsc

This module contains PowerShell DSC resources for managing Azure AD Connect
synchronization engine configurations. It enables Infrastructure as Code (IaC)
approaches for Azure AD Connect sync rules, directory extension attributes, and
related synchronization settings through declarative configuration management.

[![Build Status](https://dev.azure.com/dsccommunity/AADConnectDsc/_apis/build/status/dsccommunity.AADConnectDsc?branchName=main)](https://dev.azure.com/dsccommunity/AADConnectDsc/_build/latest?definitionId=9999&branchName=main)
![Azure DevOps coverage (branch)](https://img.shields.io/azure-devops/coverage/dsccommunity/AADConnectDsc/9999/main)
[![codecov](https://codecov.io/gh/dsccommunity/AADConnectDsc/branch/main/graph/badge.svg)](https://codecov.io/gh/dsccommunity/AADConnectDsc)
[![Azure DevOps tests](https://img.shields.io/azure-devops/tests/dsccommunity/AADConnectDsc/9999/main)](https://dsccommunity.visualstudio.com/AADConnectDsc/_test/analytics?definitionId=9999&contextType=build)
[![PowerShell Gallery (with prereleases)](https://img.shields.io/powershellgallery/vpre/AADConnectDsc?label=AADConnectDsc%20Preview)](https://www.powershellgallery.com/packages/AADConnectDsc/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/AADConnectDsc?label=AADConnectDsc)](https://www.powershellgallery.com/packages/AADConnectDsc/)

## Table of Contents

- [AADConnectDsc](#aadconnectdsc)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Resources](#resources)
  - [Requirements](#requirements)
    - [System Requirements](#system-requirements)
    - [Dependencies](#dependencies)
  - [Installation](#installation)
  - [Quick Start](#quick-start)
  - [Event Logging](#event-logging)
    - [📊 Built-in Monitoring and Auditing](#-built-in-monitoring-and-auditing)
    - [Event Log Location](#event-log-location)
    - [Event Categories](#event-categories)
      - [Compliance Events (Test Phase)](#compliance-events-test-phase)
      - [Operational Events (Set Phase)](#operational-events-set-phase)
    - [Event Information](#event-information)
    - [Example Event](#example-event)
    - [Monitoring and Automation](#monitoring-and-automation)
    - [Learn More](#learn-more)
  - [Documentation](#documentation)
    - [📚 Comprehensive Documentation](#-comprehensive-documentation)
      - [Getting Started Guides](#getting-started-guides)
      - [Resource Documentation](#resource-documentation)
      - [Advanced Topics](#advanced-topics)
      - [Examples](#examples)
    - [📖 Additional Resources](#-additional-resources)
  - [Code of Conduct](#code-of-conduct)
  - [Releases](#releases)
  - [Contributing](#contributing)
  - [Support and Community](#support-and-community)
    - [🆘 Getting Help](#-getting-help)
    - [📋 Project Resources](#-project-resources)
    - [🔗 Related Documentation](#-related-documentation)

## Features

✨ **Key Capabilities**

- **Declarative Configuration**: Manage Azure AD Connect sync rules as code
  with DSC
- **Infrastructure as Code**: Version control your sync configurations for
  consistency and repeatability
- **Automatic Precedence Management**: Intelligent handling of sync rule
  precedence values
- **Schema Extensions**: Manage directory extension attributes declaratively
- **Built-in Event Logging**: Comprehensive event logging for monitoring and
  auditing (see [Event Logging Guide](docs/EventLoggingGuide.md))
- **Idempotent Operations**: Safe to apply configurations repeatedly without
  side effects
- **Class-Based Resources**: Modern PowerShell class-based DSC resources for
  better performance
- **Migration Support**: Tools and guides for migrating from manual
  configurations (see [Migration Guide](docs/Migration.md))

## Resources

The AADConnectDsc module contains the following resources:

- **[AADSyncRule](docs/AADSyncRule.md)**: Manages Azure AD Connect
  synchronization rules including scope filters, join conditions, and attribute
  flow mappings. Supports both custom and standard sync rules with automatic
  precedence management.
  - [Basic Examples](source/Examples/Resources/AADSyncRule/1-AADSyncRule_Basic.ps1)
  - [Advanced Examples](source/Examples/Resources/AADSyncRule/2-AADSyncRule_Advanced.ps1)
- **[AADConnectDirectoryExtensionAttribute](docs/AADConnectDirectoryExtensionAttribute.md)**:
  Manages directory extension attributes for Azure AD Connect, enabling schema
  extensions for custom attribute synchronization between on-premises Active
  Directory and Azure AD.
  - [Examples](source/Examples/Resources/AADConnectDirectoryExtensionAttribute/1-AADConnectDirectoryExtensionAttribute_Examples.ps1)

## Requirements

### System Requirements

- **Windows PowerShell 5.1**: This module requires Windows PowerShell 5.1
  and does NOT work with PowerShell 7
- Windows Server 2012 R2 or later
- .NET Framework 4.6 or later

### Dependencies

- **Azure AD Connect**: This module requires Azure AD Connect to be installed
  and configured on the target system
- **ADSync Module**: The Azure AD Connect PowerShell module (automatically
  installed with Azure AD Connect)

## Installation

To install from the PowerShell Gallery:

```powershell
Install-Module -Name AADConnectDsc -Repository PSGallery
```

## Quick Start

Here's a basic example of using AADConnectDsc to manage a sync rule:

```powershell
Configuration AADConnectSample {
    Import-DscResource -ModuleName AADConnectDsc
    
    Node localhost {
        AADSyncRule 'CustomUserRule' {
            Name                = 'Custom - Inbound - User - Example'
            ConnectorName       = 'contoso.com'
            Direction           = 'Inbound'
            TargetObjectType    = 'person'
            SourceObjectType    = 'user'
            LinkType            = 'Provision'
            Precedence          = 0
            Disabled            = $false
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
                }
            )
            Ensure              = 'Present'
        }
    }
}

# Compile and apply the configuration
AADConnectSample -OutputPath 'C:\DSC'
Start-DscConfiguration -Path 'C:\DSC' -Wait -Verbose
```

**💡 Next Steps:**

- Review the [Best Practices Guide](docs/BestPractices.md) for production
  deployment guidance
- Explore [more examples](source/Examples/Resources/) for advanced scenarios
- Learn about [troubleshooting](docs/Troubleshooting.md) common issues
- Understand the [architecture](docs/Architecture.md) for deeper insights

## Event Logging

### 📊 Built-in Monitoring and Auditing

The AADConnectDsc module includes comprehensive event logging functionality
that automatically writes detailed operational events to the Windows Event Log,
enabling monitoring, auditing, and troubleshooting of DSC configuration changes.

**All DSC operations are automatically logged** - no additional configuration
required!

### Event Log Location

Events are written to a dedicated event log:

- **Event Log Name**: `AADConnectDsc`
- **Event Source**: `AADConnectDsc`

View events in Event Viewer under: `Applications and Services Logs >
AADConnectDsc`

### Event Categories

The module logs two categories of events:

#### Compliance Events (Test Phase)

These events are generated when DSC checks configuration compliance:

- **Event ID 1000** (Information): Sync rule is in desired state
- **Event ID 1001** (Warning): Sync rule absent but should be present
- **Event ID 1002** (Warning): Sync rule present but should be absent
- **Event ID 1003** (Warning): Configuration drift detected

#### Operational Events (Set Phase)

These events are generated when DSC makes configuration changes:

- **Event ID 2000** (Information): Sync rule created successfully
- **Event ID 2001** (Information): Sync rule updated successfully
- **Event ID 2002** (Information): Standard sync rule disabled state changed
- **Event ID 2003** (Information): Sync rule removed successfully

### Event Information

Each event includes rich contextual information:

- Sync rule name and connector
- Direction (Inbound/Outbound)
- Object types (source and target)
- Precedence value
- Enabled/disabled state
- Rule type (Microsoft Standard or Custom)
- Operation details (for Set operations)
- Rule complexity metrics (filter groups, mappings)

### Example Event

```text
Sync rule created successfully

Sync Rule Details:
  Rule Name: Custom - Inbound - User - Department
  Connector: contoso.com
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

### Monitoring and Automation

Event logging enables:

- **Real-time Monitoring**: Track configuration changes as they happen
- **Compliance Auditing**: Detect and report configuration drift
- **Automated Alerts**: Configure Event Viewer subscriptions or SCOM alerts
- **Change History**: Maintain audit trail of all DSC operations
- **Troubleshooting**: Diagnose configuration issues with detailed context

### Learn More

- **[Event Logging Guide](docs/EventLoggingGuide.md)**: Complete documentation
  including setup, permissions, and advanced scenarios
- **[Event Log Examples](docs/EventLogExamples.md)**: Sample event entries for
  all event IDs with detailed explanations

## Documentation

### 📚 Comprehensive Documentation

This module includes extensive documentation to help you get started and
master Azure AD Connect DSC management:

#### Getting Started Guides

- **[Architecture Guide](docs/Architecture.md)**: Understand the module
  architecture, class-based DSC resources, and component structure
- **[Best Practices](docs/BestPractices.md)**: Learn configuration design
  principles, idempotency patterns, testing strategies, and production
  deployment guidelines
- **[Migration Guide](docs/Migration.md)**: Step-by-step instructions for
  migrating from manual Azure AD Connect configurations to declarative DSC
  management

#### Resource Documentation

- **[AADSyncRule](docs/AADSyncRule.md)**: Complete reference for managing
  synchronization rules including properties, examples, and advanced scenarios
- **[AADConnectDirectoryExtensionAttribute](docs/AADConnectDirectoryExtensionAttribute.md)**:
  Schema extension management for custom attribute synchronization

#### Advanced Topics

- **[Functions Reference](docs/Functions.md)**: Documentation for all public
  functions including `Get-ADSyncRule`, directory extension management, and
  utility functions
- **[Troubleshooting Guide](docs/Troubleshooting.md)**: Solutions for common
  issues, debugging techniques, and diagnostic procedures
- **[Event Logging Guide](docs/EventLoggingGuide.md)**: Comprehensive guide to
  the built-in event logging functionality, including event IDs, configuration,
  and monitoring strategies

#### Examples

Practical configuration examples for all scenarios:

- **[Complete Configuration](source/Examples/Resources/Complete/1-AADConnectDsc_CompleteConfiguration.ps1)**:
  End-to-end example with multiple resources
- **[AADSyncRule Basic Examples](source/Examples/Resources/AADSyncRule/1-AADSyncRule_Basic.ps1)**:
  Simple sync rule configurations
- **[AADSyncRule Advanced Examples](source/Examples/Resources/AADSyncRule/2-AADSyncRule_Advanced.ps1)**:
  Complex scenarios with scope filters and attribute mappings
- **[Directory Extension Examples](source/Examples/Resources/AADConnectDirectoryExtensionAttribute/1-AADConnectDirectoryExtensionAttribute_Examples.ps1)**:
  Schema extension attribute management

All examples are also available in the [AADConnectDsc Wiki](https://github.com/dsccommunity/AADConnectDsc/wiki).

### 📖 Additional Resources

- **[Wiki](https://github.com/dsccommunity/AADConnectDsc/wiki)**: Auto-generated
  documentation from resource schemas
- **[Change Log](CHANGELOG.md)**: Complete version history and release notes
- **[Event Log Examples](docs/EventLogExamples.md)**: Sample event log entries
  and monitoring patterns

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).

## Releases

For each merge to the branch `main` a preview release will be deployed to
[PowerShell Gallery](https://www.powershellgallery.com/). Periodically a
release version tag will be pushed which will deploy a full release to
[PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Community
[contributing guidelines](https://dsccommunity.org/guidelines/contributing) and
our [Contributing Guide](CONTRIBUTING.md) for specific details about this
project.

## Support and Community

### 🆘 Getting Help

- **[Troubleshooting Guide](docs/Troubleshooting.md)**: Solutions for common
  issues and diagnostic procedures
- **[Event Logging](docs/EventLoggingGuide.md)**: Monitor and audit DSC
  operations with comprehensive event logging
- **[Best Practices](docs/BestPractices.md)**: Production deployment guidance
  and configuration patterns
- **[DSC Community](https://dsccommunity.org/)**: Join the broader DSC
  community for support and discussions

### 📋 Project Resources

- **[Security Policy](SECURITY.md)**: Report security vulnerabilities
  responsibly
- **[Code of Conduct](CODE_OF_CONDUCT.md)**: Community guidelines and
  expectations
- **[License](LICENSE)**: MIT License details

### 🔗 Related Documentation

- [Azure AD Connect Documentation](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/)
- [PowerShell DSC Documentation](https://docs.microsoft.com/en-us/powershell/dsc/)
- [DSC Community Resources](https://dsccommunity.org/)
