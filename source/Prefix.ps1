Add-Type -TypeDefinition @'
public class DscParameter : System.Attribute
{
    public DscParameter() { }
}
'@ -IgnoreWarnings -WarningAction SilentlyContinue

Import-Module -Name ADSync -Force
