<#
.SYNOPSIS
    Converts a PowerShell object to a hashtable.

.DESCRIPTION
    The Convert-ObjectToHashtable function converts any PowerShell object to a hashtable by
    extracting all properties and their values. This utility function is commonly used in
    DSC configurations and Azure AD Connect management scenarios where hashtable representations
    of objects are needed for parameter passing or configuration storage.
    
    The function filters out properties with null values to create a clean hashtable with only
    meaningful data. This is particularly useful when working with Azure AD Connect objects
    that may have many optional properties.
    
    This function works with both Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Object
    Specifies the PowerShell object to convert to a hashtable. The object can be of any type
    that has properties accessible through the PSObject.Properties collection.

.EXAMPLE
    $syncRule = Get-ADSyncRule -Name "In from AD - User Common"
    $hashtable = Convert-ObjectToHashtable -Object $syncRule
    
    Converts an Azure AD Connect synchronization rule object to a hashtable.

.EXAMPLE
    Get-ADSyncRule | Select-Object -First 1 | Convert-ObjectToHashtable
    
    Retrieves a synchronization rule and converts it to a hashtable using pipeline input.

.EXAMPLE
    $user = [PSCustomObject]@{
        Name = "John Doe"
        Email = "john.doe@contoso.com"
        Department = $null
        Enabled = $true
    }
    $hashtable = Convert-ObjectToHashtable -Object $user
    # Results in: @{ Name = "John Doe"; Email = "john.doe@contoso.com"; Enabled = $true }
    
    Converts a custom object to a hashtable, excluding null properties.

.EXAMPLE
    $config = @{
        SyncRules = Get-ADSyncRule | ForEach-Object { Convert-ObjectToHashtable $_ }
    }
    
    Creates a configuration hashtable containing all synchronization rules as hashtables.

.INPUTS
    Object. You can pipe any PowerShell object to Convert-ObjectToHashtable.

.OUTPUTS
    Hashtable. Returns a hashtable containing all non-null properties and their values.

.NOTES
    - This function works with both Windows PowerShell 5.1 and PowerShell 7
    - Properties with null values are excluded from the resulting hashtable
    - Complex nested objects are included as-is (not recursively converted)
    - The function is optimized for performance and memory efficiency
    - Useful for DSC configurations and Azure AD Connect object manipulation

.LINK
    https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable

.COMPONENT
    AADConnectDsc

.FUNCTIONALITY
    PowerShell Object Utilities
#>
function Convert-ObjectToHashtable
{
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]$Object
    )

    process
    {
        $hashtable = @{ }

        foreach ($property in $Object.PSObject.Properties.Where({ $null -ne $_.Value }))
        {
            $hashtable.Add($property.Name, $property.Value)
        }

        $hashtable
    }
}
