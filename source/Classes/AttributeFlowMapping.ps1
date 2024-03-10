[DscParameter()]
class AttributeFlowMapping
{
    AttributeFlowMapping()
    {
    }

    [DscProperty(Key)]
    [string]$Destination

    [DscProperty()]
    [bool]$ExecuteOnce

    [DscProperty()]
    [string]$Expression

    [DscProperty()]
    [AttributeMappingFlowType]$FlowType

    [DscProperty(NotConfigurable)]
    [string]$MappingSourceAsString

    [DscProperty()]
    [string[]]$Source

    [DscProperty()]
    [AttributeValueMergeType]$ValueMergeType
}
