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

## Resources

The AADConnectDsc module contains the following resources:

- **AADSyncRule**: Manages Azure AD Connect synchronization rules including
  scope filters, join conditions, and attribute flow mappings. Supports both
  custom and standard sync rules with automatic precedence management.
- **AADConnectDirectoryExtensionAttribute**: Manages directory extension
  attributes for Azure AD Connect, enabling schema extensions for custom
  attribute synchronization between on-premises Active Directory and Azure AD.

## Requirements

### System Requirements

- Windows PowerShell 5.0 or PowerShell 7.x
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
```

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).

## Releases

For each merge to the branch `main` a preview release will be deployed to
[PowerShell Gallery](https://www.powershellgallery.com/). Periodically a
release version tag will be pushed which will deploy a full release to
[PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Community
[contributing guidelines](https://dsccommunity.org/guidelines/contributing).

## Change log

A full list of changes in each version can be found in the
[change log](CHANGELOG.md).

## Documentation

The documentation can be found in the
[AADConnectDsc Wiki](https://github.com/dsccommunity/AADConnectDsc/wiki).
The DSC resources schema files are used to automatically update the
documentation on each PR merge.

### Examples

You can review the [Examples](source/Examples) directory in the AADConnectDsc
module for some general use scenarios for all of the resources that are in the
module.

The resource examples are also available in the
[AADConnectDsc Wiki](https://github.com/dsccommunity/AADConnectDsc/wiki).
