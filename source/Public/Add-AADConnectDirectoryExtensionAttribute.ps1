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

    process {

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
        }) {
            Write-Error "The attribute '$Name' with the type '$Type' assigned to the class '$AssignedObjectClass' is already defined."
            return
        }

        if (($existingAttribute = $currentAttributes | Where-Object {
                    $_.Name -eq $Name -and
                    $_.Type -ne $Type
        }) -and -not $Force) {
            Write-Error "The attribute '$Name' is already defined with the type '$($existingAttribute.Type)'."
            return
        }
        else {
            $existingAttribute | Remove-AADConnectDirectoryExtensionAttribute
        }

        $settings = Get-ADSyncGlobalSettings
        $attributeParameter = $settings.Parameters | Where-Object Name -eq Microsoft.OptionalFeature.DirectoryExtensionAttributes
        $currentAttributeList = $attributeParameter.Value -split ','

        $newAttributeString = "$Name.$AssignedObjectClass.$Type.$IsEnabled"
        $currentAttributeList += $newAttributeString

        $attributeParameter.Value = $currentAttributeList -join ','
        $settings.Parameters.AddOrReplace($attributeParameter)

        Set-ADSyncGlobalSettings -GlobalSettings $settings | Out-Null

    }
}
