Add-Type -TypeDefinition @'
public class DscParameter : System.Attribute
{
    public DscParameter() { }
}
'@ -IgnoreWarnings -WarningAction SilentlyContinue

if (-not (Get-Module -Name ADSync))
{
    Import-Module -Name ADSync
}
