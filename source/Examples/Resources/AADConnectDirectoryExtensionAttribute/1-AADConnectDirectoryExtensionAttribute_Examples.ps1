<#
.EXAMPLE 1

This example creates a directory extension attribute for storing a custom
employee ID that will be synchronized between Active Directory and Azure AD.
#>

configuration Example_AADConnectDirectoryExtensionAttribute_Basic
{
    Import-DscResource -ModuleName AADConnectDsc

    node localhost
    {
        AADConnectDirectoryExtensionAttribute 'EmployeeIDExtension'
        {
            Name                = 'employeeID'
            AssignedObjectClass = 'user'
            type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
    }
}

<#
.EXAMPLE 2

This example creates multiple directory extension attributes for different
data types that can be used in sync rules for custom attribute flows.
#>

configuration Example_AADConnectDirectoryExtensionAttribute_Multiple
{
    Import-DscResource -ModuleName AADConnectDsc

    node localhost
    {
        AADConnectDirectoryExtensionAttribute 'CostCenterExtension'
        {
            Name                = 'costCenter'
            AssignedObjectClass = 'user'
            type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }

        AADConnectDirectoryExtensionAttribute 'ManagerIDExtension'
        {
            Name                = 'managerID'
            AssignedObjectClass = 'user'
            type                = 'String'
            IsEnabled           = $true
            Ensure              = 'Present'
        }

        AADConnectDirectoryExtensionAttribute 'LastLoginExtension'
        {
            Name                = 'lastLogon'
            AssignedObjectClass = 'user'
            type                = 'DateTime'
            IsEnabled           = $true
            Ensure              = 'Present'
        }
    }
}
