function Get-FMAdomRevision {
    <#
    .SYNOPSIS
    Querys existing ADOM Revisions.

    .DESCRIPTION
    Querys existing ADOM Revisions.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

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

    .PARAMETER ExpandMembers
    Fetch all or selected attributes of object members.
    string($expand member object)

    .PARAMETER Filter
    Filter the result according to a set of criteria. For detailed help
    see about_FortigateManagerFilter

    .PARAMETER Range
    Limit the number of output. For a range of [a, n], the output will contain n elements, starting from the ath matching result.

    .PARAMETER Fields
    Limit the output by returning only the attributes specified in the string array. If none specified, all attributes will be returned.

    .PARAMETER LoggingLevel
    On which level should die diagnostic Messages be logged?

    .PARAMETER NullHandler
    Parameter description

    .EXAMPLE
    Get-FMAdomRevision

    Lists the existing Adom Revisions

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
        [System.Object[]]$Sortings,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("count", "object member", "syntax")]
        [string]$Option,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ExpandMembers,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Range,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("created_by", "created_time", "desc", "locked", "name", "version")]
        [System.Object[]]$Fields,
        [string]$LoggingLevel,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $Parameter = @{
        'sortings' = @($Sortings)
        'option'   = "$Option"
        'filter'   = ($Filter | ConvertTo-FMFilterArray)
        'range'    = @($Range)
        'fields'   = @($Fields)
        'expand members'="$ExpandMembers"
    } | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMAdomRevision"
        LoggingActionValues = $explicitADOM
        method              = "get"
        Parameter           = $Parameter
        Path                = "/dvmdb/adom/$explicitADOM/revision"
    }
    if (-not [string]::IsNullOrEmpty($LoggingLevel)) { $apiCallParameter.LoggingLevel = $LoggingLevel }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
