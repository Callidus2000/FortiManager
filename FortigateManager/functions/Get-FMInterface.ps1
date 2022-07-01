function Get-FMInterface {
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

    .PARAMETER Fields
    Limit the output by returning only the attributes specified in the string array. If none specified, all attributes will be returned.

    .PARAMETER Filter
    Filter the result according to a set of criteria. For detailed help
    see about_FortigateManagerFilter

    .PARAMETER GetUsed
    Parameter description

    .PARAMETER Loadsub
    Enable or disable the return of any sub-objects. If not specified, the default is to return all sub-objects.

    .PARAMETER Option
    Set fetch option for the request. If no option is specified, by default the attributes of the objects will be returned.
    count - Return the number of matching entries instead of the actual entry data.
    scope member - Return a list of scope members along with other attributes.
    datasrc - Return all objects that can be referenced by an attribute. Require attr parameter.
    get reserved - Also return reserved objects in the result.
    syntax - Return the attribute syntax of a table or an object, instead of the actual entry data. All filter parameters will be ignored.


    .PARAMETER Range
    Limit the number of output. For a range of [a, n], the output will contain n elements, starting from the ath matching result.

    .PARAMETER Sortings
    Specify the sorting of the returned result.

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,

        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Attr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("color", "default-mapping", "defmap-intf", "defmap-intrazone-deny", "defmap-zonemember", "description", "egress-shaping-profile", "ingress-shaping-profile", "name", "single-intf", "wildcard", "wildcard-intf", "zone-only")]
        [System.Object[]]$Fields,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$GetUsed = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Loadsub = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("count", "scope member", "datasrc", "get reserved", "syntax")]
        [string]$Option,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Range,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Sortings
    )
    $Parameter = @{
        'attr'     = "$Attr"
        'fields'   = @($Fields)
        'filter'   = ($Filter | ConvertTo-FMFilterArray)
        'get used' = $GetUsed
        'loadsub'  = $Loadsub
        'option'   = "$Option"
        'range'    = @($Range)
        'sortings' = @($Sortings)
    } | Remove-FMNullValuesFromHashtable
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMInterface"
        LoggingActionValues = @($explicitADOM)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/config/adom/$explicitADOM/obj/dynamic/interface"
    }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
