function Unlock-FMAdom {
    <#
    .SYNOPSIS
    Unlocks the given ADOM.

    .DESCRIPTION
    Unlocks the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Commit
    If used the changes will be commited before unlocking the ADOM.

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
        [bool]$EnableException = $true,
        [switch]$Commit
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    if ($Commit){
        Publish-FMAdomChange -Connection $Connection -Adom $explicitADOM -EnableException $EnableException
    }
    $apiCallParameter = @{
        Connection = $Connection
        method     = "exec"
        Path       = "/dvmdb/adom/$explicitADOM/workspace/unlock"
    }

    $result = Invoke-FMAPI @apiCallParameter
    $statusCode = $result.result.status.code
    if ($statusCode -ne 0) {
        Write-PSFMessage -Level Warning "ADOM $explicitADOM could not be unlocked"
        if ($EnableException) {
            throw "ADOM $explicitADOM could not be unlocked, Error-Message: $($result.result.status.Message)"
        }
        return $false
    }
    Write-PSFMessage "ADOM $explicitADOM successfully unlocked"
   if (-not $EnableException){return $true}
}