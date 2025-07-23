<#
.SYNOPSIS
    Retrieves directory extension attributes from Azure AD Connect configuration.

.DESCRIPTION
    The Get-AADConnectDirectoryExtensionAttribute function retrieves directory extension attributes
    that are currently configured in Azure AD Connect global settings. These attributes represent
    schema extensions that allow synchronization of custom attributes from on-premises Active Directory
    to Azure AD.

    The function can retrieve all directory extension attributes or filter by a specific attribute name.
    Each returned object contains the attribute name, data type, assigned object class, and enabled status.

    This function requires Windows PowerShell 5.1 and does not work with PowerShell 7.

.PARAMETER Name
    Specifies the name of a specific directory extension attribute to retrieve. If not specified,
    all directory extension attributes are returned. Supports wildcard patterns.

.EXAMPLE
    Get-AADConnectDirectoryExtensionAttribute

    Retrieves all directory extension attributes currently configured in Azure AD Connect.

.EXAMPLE
    Get-AADConnectDirectoryExtensionAttribute -Name "employeeNumber"

    Retrieves the directory extension attribute named "employeeNumber" if it exists.

.EXAMPLE
    Get-AADConnectDirectoryExtensionAttribute -Name "employee*"

    Retrieves all directory extension attributes with names starting with "employee".

.EXAMPLE
    $attributes = Get-AADConnectDirectoryExtensionAttribute
    $attributes | Where-Object Type -eq "String"

    Retrieves all directory extension attributes and filters for those with String data type.

.INPUTS
    None. You cannot pipe objects to Get-AADConnectDirectoryExtensionAttribute.

.OUTPUTS
    PSCustomObject. Returns objects with the following properties:
    - Name: The attribute name
    - Type: The data type (String, Integer, Boolean, DateTime, etc.)
    - AssignedObjectClass: The object class (user, group, contact, device, etc.)
    - IsEnabled: Whether the attribute is enabled for synchronization

.NOTES
    - This function requires Windows PowerShell 5.1 and does not work with PowerShell 7
    - Requires Azure AD Connect to be installed and the ADSync module to be available
    - Returns an empty result if no directory extension attributes are configured
    - The returned objects can be used as input for other directory extension attribute functions

.LINK
    https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-feature-directory-extensions

.COMPONENT
    AADConnectDsc

.FUNCTIONALITY
    Azure AD Connect Directory Extension Attribute Management
#>
function Get-AADConnectDirectoryExtensionAttribute
{
    param (
        [Parameter()]
        [string]$Name
    )

    $settings = Get-ADSyncGlobalSettings
    $attributeParameter = $settings.Parameters | Where-Object Name -EQ Microsoft.OptionalFeature.DirectoryExtensionAttributes

    $attributes = $attributeParameter.Value -split ','

    if (-not $attributes)
    {
        return
    }

    if ($Name)
    {
        $attributes = $attributes | Where-Object { $_ -like "$Name.*" }
        if (-not $attributes)
        {
            Write-Error "The attribute '$Name' is not defined."
            return
        }
    }

    foreach ($attribute in $attributes)
    {
        $attribute = $attribute -split '\.'
        [pscustomobject]@{
            Name                = $attribute[0]
            Type                = $attribute[2]
            AssignedObjectClass = $attribute[1]
            IsEnabled           = $attribute[3]
        }
    }
}
