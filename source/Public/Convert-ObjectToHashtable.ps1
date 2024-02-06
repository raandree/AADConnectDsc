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

<#
function Convert-ObjectToHashtable
{
    <#

    .SYNOPSIS
        Takes a single object and converts its properties and values into a hashtable.

        .DESCRIPTION
        Takes a single object and converts its properties and values into a hashtable.

        .PARAMETER Object
        The Object to turn into a hashtable

        .PARAMETER ExcludeEmpty
        Switch to exclude empty properties

        .EXAMPLE
        Convert-ObjectToHashtable -object Value -ExcludeEmpty

        .NOTES
        Source: https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/turning-objects-into-hash-tables-2

    >

    #region parameter
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject] $object,

        [Parameter()]
        [Switch]
        $ExcludeEmpty
    )

    process
    {
        $object.PSObject.Properties |
            Sort-Object -Property Name |
                Where-Object { ($ExcludeEmpty.IsPresent -eq $false) -or ($null -ne $_.Value) } |
                    ForEach-Object -Begin {
                        $hashtable = ([Ordered]@{}) } -Process {
                        $hashtable[$_.Name] = $_.Value
                    } -End {
                        Write-Output -InputObject $hashtable
                    }
    }
}
#>
