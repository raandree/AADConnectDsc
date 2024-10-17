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
