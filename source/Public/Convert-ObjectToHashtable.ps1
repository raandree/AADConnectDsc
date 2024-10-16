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
