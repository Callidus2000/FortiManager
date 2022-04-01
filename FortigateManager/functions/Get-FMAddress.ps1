function Get-FMAddress {
    <#
    .SYNOPSIS
    Querys existing addresses.

    .DESCRIPTION
    Querys existing addresses.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Attr
    The name of the attribute to retrieve its datasource. Only used with datasrc option.

    .PARAMETER Sortings
    Specify the sorting of the returned result.

    .PARAMETER Loadsub
    Enable or disable the return of any sub-objects. If not specified, the default is to return all sub-objects.

    .PARAMETER Option
    Set fetch option for the request. If no option is specified, by default the attributes of the objects will be returned.
    count - Return the number of matching entries instead of the actual entry data.
    scope member - Return a list of scope members along with other attributes.
    datasrc - Return all objects that can be referenced by an attribute. Require attr parameter.
    get reserved - Also return reserved objects in the result.
    syntax - Return the attribute syntax of a table or an object, instead of the actual entry data. All filter parameters will be ignored.

    .PARAMETER Filter
    Filter the result according to a set of criteria.

    string
    example: @(@("{attribute}", "==", "{value}"))

    .PARAMETER GetUsed
    Parameter description

    .PARAMETER Range
    Limit the number of output. For a range of [a, n], the output will contain n elements, starting from the ath matching result.

    .PARAMETER Fields
    Limit the output by returning only the attributes specified in the string array. If none specified, all attributes will be returned.

    .PARAMETER NullHandler
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        $Connection,
        [string]$ADOM,
        [bool]$EnableException = $true,

        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Attr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Sortings,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Loadsub = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("count", "scope member", "datasrc", "get reserved", "syntax")]
        [string]$Option,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$GetUsed = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Range,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("_image-base64", "allow-routing", "associated-interface", "cache-ttl", "clearpass-spt", "color", "comment", "country", "dirty", "end-ip", "epg-name", "fabric-object", "filter", "fqdn", "fsso-group", "interface", "macaddr", "name", "node-ip-only", "obj-id", "obj-tag", "obj-type", "organization", "policy-group", "sdn", "sdn-addr-type", "sdn-tag", "start-ip", "sub-type", "subnet", "subnet-name", "tag-detection-level", "tag-type", "tenant", "type", "uuid","wildcard","wildcard-fqdn")]
        [System.Object[]]$Fields,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $ParameterData = @{
        'url'      = "$Url"
        'attr'     = "$Attr"
        'sortings' = @($Sortings)
        'loadsub'  = $Loadsub
        'option'   = "$Option"
        'filter'   = @($Filter)
        'get used' = $GetUsed
        'range'    = @($Range)
        'fields'   = @($Fields)
    } | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        Connection    = $Connection
        method        = "get"
        ParameterData = $parameterData
        Path          = "/pm/config/adom/$explicitADOM/obj/firewall/address"
    }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
