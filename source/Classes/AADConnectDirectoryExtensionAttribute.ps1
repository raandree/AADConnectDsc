[DscResource()]
class AADConnectDirectoryExtensionAttribute
{
    [DscProperty(Key = $true)]
    [string]$Name

    [DscProperty(Key = $true)]
    [string]$AssignedObjectClass

    [DscProperty(Mandatory = $true)]
    [string]$Type

    [DscProperty(Mandatory = $true)]
    [bool]$IsEnabled

    [DscProperty()]
    [Ensure]
    $Ensure

    AADConnectDirectoryExtensionAttribute()
    {
        $this.Ensure = 'Present'
    }

    [bool]Test()
    {
        $currentState = Convert-ObjectToHashtable -Object $this.Get()
        $desiredState = Convert-ObjectToHashtable -Object $this

        if ($currentState.Ensure -ne $desiredState.Ensure)
        {
            return $false
        }
        if ($desiredState.Ensure -eq [Ensure]::Absent)
        {
            return $true
        }

        $compare = Test-DscParameterState -CurrentValues $currentState -DesiredValues $desiredState -TurnOffTypeChecking -SortArrayValues

        return $compare
    }

    [AADConnectDirectoryExtensionAttribute]Get()
    {
        $currentState = [AADConnectDirectoryExtensionAttribute]::new()

        $attribute = Get-AADConnectDirectoryExtensionAttribute -Name $this.Name -ErrorAction SilentlyContinue |
            Where-Object { $_.AssignedObjectClass -eq $this.AssignedObjectClass -and $_.Type -eq $this.Type }

        $currentState.Ensure = [Ensure][int][bool]$attribute
        $CurrentState.Name = $this.Name
        $currentState.AssignedObjectClass = $this.AssignedObjectClass
        $currentState.Type = $attribute.Type
        $currentState.IsEnabled = $attribute.IsEnabled

        return $currentState
    }

    [void]Set()
    {
        $param = Convert-ObjectToHashtable $this

        if ($this.Ensure -eq 'Present')
        {
            $cmdet = Get-Command -Name Add-AADConnectDirectoryExtensionAttribute
            $param = Sync-Parameter -Command $cmdet -Parameters $param
            Add-AADConnectDirectoryExtensionAttribute @param -Force
        }
        else
        {
            $cmdet = Get-Command -Name Remove-AADConnectDirectoryExtensionAttribute
            $param = Sync-Parameter -Command $cmdet -Parameters $param
            Remove-AADConnectDirectoryExtensionAttribute @param
        }

    }
}
