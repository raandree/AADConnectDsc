<#
.SYNOPSIS
    Adds a directory extension attribute to Azure AD Connect configuration.

.DESCRIPTION
    The Add-AADConnectDirectoryExtensionAttribute function adds a new directory extension attribute
    to the Azure AD Connect global settings. Directory extension attributes allow you to extend
    the schema of Azure AD objects with custom attributes that can be synchronized from on-premises
    Active Directory.

    This function supports two parameter sets: specifying individual properties or providing a
    complete attribute string. It includes validation and conflict resolution capabilities.

    This function requires Windows PowerShell 5.1 and does not work with PowerShell 7.

.PARAMETER Name
    Specifies the name of the directory extension attribute to add. The name should be unique
    within the object class and follow Azure AD naming conventions.

.PARAMETER Type
    Specifies the data type of the directory extension attribute. Common types include:
    - String: Text data
    - Integer: Numeric data
    - Boolean: True/False values
    - DateTime: Date and time values

.PARAMETER AssignedObjectClass
    Specifies the object class to which this attribute will be assigned. Common values include:
    - user: For user objects
    - group: For group objects
    - contact: For contact objects
    - device: For device objects

.PARAMETER IsEnabled
    Specifies whether the directory extension attribute is enabled for synchronization.
    Set to $true to enable or $false to disable.

.PARAMETER FullAttributeString
    Specifies a complete attribute definition string in the format:
    "attributeName.objectClass.dataType.enabledStatus"
    For example: "employeeNumber.user.String.True"

.PARAMETER Force
    Forces the addition of the attribute even if a conflicting attribute with the same name
    but different type exists. When specified, the existing conflicting attribute is removed.

.EXAMPLE
    Add-AADConnectDirectoryExtensionAttribute -Name "employeeNumber" -Type "String" -AssignedObjectClass "user" -IsEnabled $true

    Adds an employee number attribute for user objects as a string type.

.EXAMPLE
    Add-AADConnectDirectoryExtensionAttribute -FullAttributeString "departmentCode.user.String.True"

    Adds a department code attribute using the full attribute string format.

.EXAMPLE
    Add-AADConnectDirectoryExtensionAttribute -Name "badgeNumber" -Type "Integer" -AssignedObjectClass "user" -IsEnabled $true -Force

    Adds a badge number attribute, replacing any existing conflicting attribute with the same name.

.EXAMPLE
    Get-Content "attributes.txt" | ForEach-Object { Add-AADConnectDirectoryExtensionAttribute -FullAttributeString $_ }

    Adds multiple attributes from a text file, with each line containing a full attribute string.

.INPUTS
    String. You can pipe attribute strings to this function when using the FullAttributeString parameter.

.OUTPUTS
    None. This function does not return objects but modifies Azure AD Connect global settings.

.NOTES
    - This function requires Windows PowerShell 5.1 and does not work with PowerShell 7
    - Requires Azure AD Connect to be installed and the ADSync module to be available
    - Changes take effect immediately but may require synchronization cycle restart
    - Use Get-AADConnectDirectoryExtensionAttribute to verify the attribute was added successfully
    - Directory extension attributes are permanent once synchronized to Azure AD

.LINK
    https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-feature-directory-extensions

.COMPONENT
    AADConnectDsc

.FUNCTIONALITY
    Azure AD Connect Directory Extension Attribute Management
#>
function Add-AADConnectDirectoryExtensionAttribute
{
    [CmdletBinding(DefaultParameterSetName = 'ByProperties')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$Name,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$Type,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$AssignedObjectClass,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [bool]$IsEnabled,

        [Parameter(Mandatory = $true, ParameterSetName = 'SingleObject')]
        [string]$FullAttributeString,

        [Parameter()]
        [switch]$Force
    )

    process
    {
        $currentAttributes = Get-AADConnectDirectoryExtensionAttribute

        if ($FullAttributeString)
        {
            $attributeValues = $FullAttributeString -split '\.'
            if ($attributeValues.Count -ne 4)
            {
                Write-Error "The attribute string did not have the correct format. Make sure it is like 'attributeName.group.String.True'"
                return
            }
            $Name = $attributeValues[0]
            $AssignedObjectClass = $attributeValues[1]
            $Type = $attributeValues[2]
            $IsEnabled = $attributeValues[3]
        }

        if ($currentAttributes | Where-Object {
                $_.Name -eq $Name -and
                $_.AssignedObjectClass -eq $AssignedObjectClass -and
                $_.Type -eq $Type -and
                $_.IsEnabled -eq $IsEnabled
            })
        {
            Write-Error "The attribute '$Name' with the type '$Type' assigned to the class '$AssignedObjectClass' is already defined."
            return
        }

        if (($existingAttribute = $currentAttributes | Where-Object {
                    $_.Name -eq $Name -and
                    $_.Type -ne $Type
                }) -and -not $Force)
        {
            Write-Error "The attribute '$Name' is already defined with the type '$($existingAttribute.Type)'."
            return
        }
        else
        {
            $existingAttribute | Remove-AADConnectDirectoryExtensionAttribute
        }

        $settings = Get-ADSyncGlobalSettings
        $attributeParameter = $settings.Parameters | Where-Object Name -EQ Microsoft.OptionalFeature.DirectoryExtensionAttributes
        $currentAttributeList = $attributeParameter.Value -split ','

        $newAttributeString = "$Name.$AssignedObjectClass.$Type.$IsEnabled"
        $currentAttributeList += $newAttributeString

        $attributeParameter.Value = $currentAttributeList -join ','
        $settings.Parameters.AddOrReplace($attributeParameter)

        Set-ADSyncGlobalSettings -GlobalSettings $settings | Out-Null
    }
}
