function Get-FMAdomLockStatus {
    <#
    .SYNOPSIS
    Query the lockstatus of the given ADOM.

    .DESCRIPTION
    Query the lockstatus of the given ADOM.
    Returns null if not locked, otherwise detailed information is returned.
  	.PARAMETER EnableException
	Should Exceptions been thrown?


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
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMAdomLockStatus"
        LoggingActionValues = $explicitADOM
        method              = "get"
        Path                = "/dvmdb/adom/$explicitADOM/workspace/lockinfo"
    }

    $result = Invoke-FMAPI @apiCallParameter
    return $result.result.data
}