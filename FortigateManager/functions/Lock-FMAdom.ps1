function Lock-FMAdom {
    <#
    .SYNOPSIS
    Locks the given ADOM.

    .DESCRIPTION
    Locks the given ADOM.

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
        method     = "exec"
        Path       = "/dvmdb/adom/$explicitADOM/workspace/lock"
    }

    $result = Invoke-FMAPI @apiCallParameter
    $statusCode = $result.result.status.code
    if ($statusCode -ne 0) {
        Write-PSFMessage -Level Warning "ADOM $explicitADOM could not be locked"
        if ($EnableException) {
            throw "ADOM $explicitADOM could not be locked, Error-Message: $($result.result.status.Message)"
        }
        return $false
    }
    Write-PSFMessage "ADOM $explicitADOM successfully locked"
   if (-not $EnableException){return $true}
}