[DscParameter()]
class ScopeCondition
{
    [DscProperty()]
    [string]$Attribute

    [DscProperty()]
    [string]$ComparisonValue

    [DscProperty()]
    [ComparisonOperator]$ComparisonOperator

    ScopeCondition() { }

    ScopeCondition([hashtable]$Definition)
    {
        $this.Attribute = $Definition['Attribute']
        $this.ComparisonValue = $Definition['ComparisonValue']
        $this.ComparisonOperator = $Definition['ComparisonOperator']
    }

    ScopeCondition([string]$Attribute, [string]$ComparisonValue, [string]$ComparisonOperator)
    {
        $this.Attribute = $Attribute
        $this.ComparisonValue = $ComparisonValue
        $this.ComparisonOperator = $ComparisonOperator
    }
}
