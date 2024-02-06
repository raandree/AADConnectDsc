[DscParameter()]
class ScopeConditionGroup
{
    [DscProperty()]
    [ScopeCondition[]]$ScopeConditionList

    ScopeConditionGroup() {
    }
}
