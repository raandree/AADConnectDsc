[DscParameter()]
class JoinCondition
{
    [DscProperty()]
    [string]$CSAttribute

    [DscProperty()]
    [string]$MVAttribute

    [DscProperty()]
    [bool]$CaseSensitive

    JoinCondition() { }

    JoinCondition([string]$CSAttribute, [string]$MVAttribute, [bool]$CaseSensitive) {
        $this.CSAttribute = $CSAttribute
        $this.MVAttribute = $MVAttribute
        $this.CaseSensitive = $CaseSensitive
    }
}
