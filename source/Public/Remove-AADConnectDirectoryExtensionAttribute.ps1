<#
.SYNOPSIS
    Removes a directory extension attribute from Azure AD Connect configuration.

.DESCRIPTION
    The Remove-AADConnectDirectoryExtensionAttribute function removes a directory extension attribute
    from the Azure AD Connect global settings. This function allows you to clean up unused or
    incorrectly configured directory extension attributes from the synchronization configuration.

    The function supports two parameter sets: specifying individual properties or providing a
    complete attribute string. It includes validation to ensure the attribute exists before removal.

    WARNING: Removing a directory extension attribute that is actively used in synchronization
    rules may cause synchronization errors. Ensure the attribute is not referenced before removal.

    This function requires Windows PowerShell 5.1 and does not work with PowerShell 7.

.PARAMETER Name
    Specifies the name of the directory extension attribute to remove. Must match exactly with
    an existing attribute name.

.PARAMETER Type
    Specifies the data type of the directory extension attribute to remove. Must match exactly
    with the existing attribute's type (String, Integer, Boolean, DateTime, etc.).

.PARAMETER AssignedObjectClass
    Specifies the object class of the directory extension attribute to remove. Must match exactly
    with the existing attribute's object class (user, group, contact, device, etc.).

.PARAMETER FullAttributeString
    Specifies a complete attribute definition string in the format:
    "attributeName.objectClass.dataType.enabledStatus"
    For example: "employeeNumber.user.String.True"

.EXAMPLE
    Remove-AADConnectDirectoryExtensionAttribute -Name "employeeNumber" -Type "String" -AssignedObjectClass "user"

    Removes the employee number directory extension attribute for user objects.

.EXAMPLE
    Remove-AADConnectDirectoryExtensionAttribute -FullAttributeString "departmentCode.user.String.True"

    Removes the department code directory extension attribute using the full attribute string format.

.EXAMPLE
    Get-AADConnectDirectoryExtensionAttribute -Name "obsolete*" | Remove-AADConnectDirectoryExtensionAttribute

    Removes all directory extension attributes with names starting with "obsolete".

.EXAMPLE
    $attribute = Get-AADConnectDirectoryExtensionAttribute -Name "tempAttribute"
    if ($attribute) {
        Remove-AADConnectDirectoryExtensionAttribute -Name $attribute.Name -Type $attribute.Type -AssignedObjectClass $attribute.AssignedObjectClass
    }

    Safely removes a directory extension attribute after verifying it exists.

.INPUTS
    PSCustomObject. You can pipe directory extension attribute objects from Get-AADConnectDirectoryExtensionAttribute.

.OUTPUTS
    None. This function does not return objects but modifies Azure AD Connect global settings.

.NOTES
    - This function requires Windows PowerShell 5.1 and does not work with PowerShell 7
    - Requires Azure AD Connect to be installed and the ADSync module to be available
    - Changes take effect immediately but may require synchronization cycle restart
    - Verify that the attribute is not used in synchronization rules before removal
    - Use Get-AADConnectDirectoryExtensionAttribute to verify the attribute was removed successfully
    - Removed attributes cannot be recovered; back up configuration before making changes

.LINK
    https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-feature-directory-extensions

.COMPONENT
    AADConnectDsc

.FUNCTIONALITY
    Azure AD Connect Directory Extension Attribute Management
#>
function Remove-AADConnectDirectoryExtensionAttribute
{
    [CmdletBinding(DefaultParameterSetName = 'ByProperties')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$Name,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$Type,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByProperties')]
        [string]$AssignedObjectClass,

        [Parameter(Mandatory = $true, ParameterSetName = 'SingleObject')]
        $FullAttributeString
    )

    process
    {
        $currentAttributes = Get-AADConnectDirectoryExtensionAttribute

        if ($FullAttributeString)
        {
            $attributeValues = $FullAttributeString -split '\.'
            if ($attributeValues.Count -ne 4)
            {
                Write-Error "The attribute string did not have the correct format. Make sure it is like 'attributeName.group.String.True'".
                return
            }
            $Name = $attributeValues[0]
            $AssignedObjectClass = $attributeValues[1]
            $Type = $attributeValues[2]
            $IsEnabled = $attributeValues[3]
        }

        if (-not ($existingAttribute = $currentAttributes | Where-Object {
                    $_.Name -eq $Name -and
                    $_.AssignedObjectClass -eq $AssignedObjectClass -and
                    $_.Type -eq $Type
                }))
        {
            Write-Error "The attribute '$Name' with the type '$Type' assigned to the class '$AssignedObjectClass' is not defined."
            return
        }

        $settings = Get-ADSyncGlobalSettings
        $attributeParameter = $settings.Parameters | Where-Object Name -EQ Microsoft.OptionalFeature.DirectoryExtensionAttributes
        $currentAttributeList = $attributeParameter.Value -split ','

        $attributeStringToRemove = "$($existingAttribute.Name).$($existingAttribute.AssignedObjectClass).$($existingAttribute.Type).$($existingAttribute.IsEnabled)"
        $currentAttributeList = $currentAttributeList -ne $attributeStringToRemove

        $attributeParameter.Value = $currentAttributeList -join ','
        $settings.Parameters.AddOrReplace($attributeParameter)

        Set-ADSyncGlobalSettings -GlobalSettings $settings | Out-Null
    }
}
