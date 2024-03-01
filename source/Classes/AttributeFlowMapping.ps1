[DscParameter()]
class AttributeFlowMapping
{
    AttributeFlowMapping()
    {
    }

    [DscProperty()]
    [string]$Destination

    [DscProperty()]
    [bool]$ExecuteOnce

    [DscProperty()]
    [string]$Expression

    [DscProperty()]
    [AttributeMappingFlowType]$FlowType

    [DscProperty(NotConfigurable)]
    [string]$MappingSourceAsString

    #[DscProperty()]
    #[string[]]$MappingSourceAsString

    [DscProperty()]
    [AttributeValueMergeType]$ValueMergeType
}
