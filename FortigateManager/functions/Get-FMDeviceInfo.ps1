function Get-FMDeviceInfo {
    <#
    .SYNOPSIS
    Querys Device Information.

    .DESCRIPTION
    Querys Device Information.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Option
    Set fetch option for the request. If no option is specified, by default the attributes of the object will be returned.
    object member - Return a list of object members along with other attributes.
    chksum - Return the check-sum value instead of attributes.

    .PARAMETER NoAdom
    If used, no ADOM will be used and all ADOMs will be queried.
    .EXAMPLE
    An example

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
        [ValidateSet("object member", "chksum")]
        [string]$Option,
        [switch]$NoADOM
    )
    $Parameter = @{
        'option' = "$Option"
    } | Remove-FMNullValuesFromHashtable -NullHandler "RemoveAttribute"
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMDeviceInfo"
        LoggingActionValues = $explicitADOM
        method              = "get"
        Parameter           = $Parameter
        Path                = "/dvmdb/adom/$explicitADOM"
    }
    if ($NoADOM) {
        $apiCallParameter.Path = "/dvmdb/adom"
        $apiCallParameter.LoggingActionValues ="noAdom"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
