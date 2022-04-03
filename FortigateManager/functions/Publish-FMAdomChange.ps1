function Publish-FMAdomChange {
    <#
    .SYNOPSIS
    Commits changes to the given ADOM.

    .DESCRIPTION
    Commits changes to the given ADOM.

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
        Path       = "/dvmdb/adom/$explicitADOM/workspace/commit"
    }

    $result = Invoke-FMAPI @apiCallParameter
    $statusCode = $result.result.status.code
    if ($statusCode -ne 0) {
        Write-PSFMessage -Level Warning "ADOM $explicitADOM could not be commited"
        if ($EnableException) {
            throw "ADOM $explicitADOM could not be commited, Error-Message: $($result.result.status.Message)"
        }
        return $false
    }
    Write-PSFMessage "ADOM $explicitADOM successfully commited"
   if (-not $EnableException){return $true}
}