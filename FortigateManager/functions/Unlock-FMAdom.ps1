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

  	.PARAMETER EnableException
	Should Exceptions been thrown?

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
        [bool]$EnableException = $true,
        [switch]$Commit
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    if ($Commit) {
        Publish-FMAdomChange -Connection $Connection -Adom $explicitADOM -EnableException $EnableException
    }
    if (-not [string]::IsNullOrEmpty($Connection.forti.defaultRevisionNote)){
        Write-PSFMessage "Removing defaultRevisionNote from Connection"
        $Connection.forti.remove("defaultRevisionNote")
    }
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Unlock-FMAdom"
        LoggingActionValues = $explicitADOM
        method              = "exec"
        Path                = "/dvmdb/adom/$explicitADOM/workspace/unlock"
    }

    $result = Invoke-FMAPI @apiCallParameter
    # If EnableException an exception would have be thrown, otherwise the function returns true for success or false for failure
    if (-not $EnableException) {
        return ($null -ne $result)
    }
}