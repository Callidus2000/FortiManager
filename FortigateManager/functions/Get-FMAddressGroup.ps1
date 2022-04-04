function Get-FMAddressGroup {
    <#
    .SYNOPSIS
    Query the addressgroups of the given ADOM.

    .DESCRIPTION
    Query the addressgroups of the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .EXAMPLE
    To be added

    in the Future

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        $Connection,
        [string]$ADOM,
        [bool]$EnableException = $true
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException = $EnableException
        Connection      = $Connection
        method          = "get"
        Path            = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp"
    }

    $result = Invoke-FMAPI @apiCallParameter
    return $result.result.data
}