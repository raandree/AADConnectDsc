task AddTypes {

    <#
    Add-Type -TypeDefinition @'
public class DscParameter : System.Attribute
{
    public DscParameter() { }
}
'@ -IgnoreWarnings -WarningAction SilentlyContinue

    if (-not (Test-Path -Path "$ProjectPath\.temp\Microsoft Azure AD Sync"))
    {
        Expand-Archive -Path "$ProjectPath\.temp\Microsoft Azure AD Sync.zip" -DestinationPath "$ProjectPath\.temp"
    }
#>

    Import-Module -Name "$ProjectPath\.temp\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1" -Force

}
