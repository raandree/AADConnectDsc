class AttributeFlowMapping
{
    AttributeFlowMapping()
    {
    }

    [DscProperty(Key)]
    [string]$Destination

    [DscProperty()]
    [bool]$ExecuteOnce

    [DscProperty(Key)]
    [string]$Expression

    [DscProperty(Key)]
    [AttributeMappingFlowType]$FlowType

    [DscProperty(NotConfigurable)]
    [string]$MappingSourceAsString

    [DscProperty(Key)]
    [string]$Source

    [DscProperty()]
    [AttributeValueMergeType]$ValueMergeType
}
