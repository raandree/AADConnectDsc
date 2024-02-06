[DscParameter()]
class JoinConditionGroup
{
    [DscProperty()]
    [JoinCondition[]]$JoinConditionList

    ScopeConditionGroup() {
    }
}
