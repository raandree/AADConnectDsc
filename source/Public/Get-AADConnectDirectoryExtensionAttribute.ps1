function Get-AADConnectDirectoryExtensionAttribute
{
    param (
        [Parameter()]
        [string]$Name
    )

    $settings = Get-ADSyncGlobalSettings
    $attributeParameter = $settings.Parameters | Where-Object Name -eq Microsoft.OptionalFeature.DirectoryExtensionAttributes

    $attributes = $attributeParameter.Value -split ','

    if (-not $attributes)
    {
        return
    }

    if ($Name) {
        $attributes = $attributes | Where-Object { $_ -like "$Name.*" }
        if (-not $attributes) {
            Write-Error "The attribute '$Name' is not defined."
            return
        }
    }

    foreach ($attribute in $attributes) {
        $attribute = $attribute -split '\.'
        [pscustomobject]@{
            Name = $attribute[0]
            Type = $attribute[2]
            AssignedObjectClass = $attribute[1]
            IsEnabled = $attribute[3]
        }
    }
}
