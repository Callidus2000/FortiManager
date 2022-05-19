function Get-FMPolicyPackage {
    <#
    .SYNOPSIS
    Querys existing Policies.

    .DESCRIPTION
    Querys existing Policies.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Name
    The name of the Package

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
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,

        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("name", "obj ver", "oid", "scope member", "type")]
        [System.Object[]]$Fields,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    # 'pkg_path'     = "$PkgPath"
    $Parameter = @{
        'fields'   = @($Fields)
    } | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMPolicyPackage"
        LoggingActionValues = ($Parameter.Keys.Count)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/pkg/adom/$explicitADOM"
    }
    if ($Name){
            $apiCallParameter.Path+="/$Name"
    }
    $result = Invoke-FMAPI @apiCallParameter -verbose
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
