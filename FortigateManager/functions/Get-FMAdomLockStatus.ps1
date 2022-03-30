function Get-FMAdomLockStatus {
    <#
    .SYNOPSIS
    Query the lockstatus of the given ADOM.

    .DESCRIPTION
    Query the lockstatus of the given ADOM.
    Returns null if not locked, otherwise detailed information is returned.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

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
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    $apiCallParameter = @{
        Connection = $Connection
        method     = "get"
        Path       = "/dvmdb/adom/$explicitADOM/workspace/lockinfo"
    }

    $result = Invoke-FMAPI @apiCallParameter
    $statusCode = $result.result.status.code
    if ($statusCode -ne 0) {
        Write-PSFMessage -Level Warning "Could not get Lockstatus of ADOM $explicitADOM"
        if ($EnableException) {
            throw "ADOM $explicitADOM could not be locked, Error-Message: $($result.result.status.Message)"
        }
        # return $false
    }

    return $result.result.data
}