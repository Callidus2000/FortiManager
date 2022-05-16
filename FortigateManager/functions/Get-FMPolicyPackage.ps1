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
        [ValidateSet("_image-base64", "allow-routing", "associated-interface", "cache-ttl", "clearpass-spt", "color", "comment", "country", "dirty", "end-ip", "epg-name", "fabric-object", "filter", "fqdn", "fsso-group", "interface", "macaddr", "name", "node-ip-only", "obj-id", "obj-tag", "obj-type", "organization", "policy-group", "sdn", "sdn-addr-type", "sdn-tag", "start-ip", "sub-type", "subnet", "subnet-name", "tag-detection-level", "tag-type", "tenant", "type", "uuid", "wildcard", "wildcard-fqdn")]
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
        LoggingAction       = "Get-FMPolicy"
        LoggingActionValues = ($Parameter.Keys.Count)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/pkg/adom/$explicitADOM"
    }
    if ($Name){
            $apiCallParameter.Path+="/$Name"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
