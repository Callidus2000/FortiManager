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
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Publish-FMAdomChange"
        method              = "exec"
        Path                = "/dvmdb/adom/$explicitADOM/workspace/commit"
    }

    $result = Invoke-FMAPI @apiCallParameter
    if (-not $EnableException) {
        return ($null -ne $result)
    }
}