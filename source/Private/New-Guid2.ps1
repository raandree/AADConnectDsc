function New-Guid2
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $InputString
    )

    $md5 = [System.Security.Cryptography.MD5]::Create()

    $hash = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($InputString))
    return [System.Guid]::new($hash).Guid
}
