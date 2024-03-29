﻿function Lock-FMAdom {
    <#
    .SYNOPSIS
    Locks the given ADOM.

    .DESCRIPTION
    Locks the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER RevisionNote
    The default revision note for all set, add, update, delete, move and clone calls

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
        [parameter(Mandatory=$true)]
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    # $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    Write-PSFMessage "Adding defaultRevisionNote to Connection"
    $Connection.forti.defaultRevisionNote = $RevisionNote
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    # Write-PSFMessage "`$explicitADOM=$explicitADOM"
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Lock-FMAdom"
        LoggingActionValues = $explicitADOM
        method              = "exec"
        Path                = "/dvmdb/adom/$explicitADOM/workspace/lock"
    }
    $result = Invoke-FMAPI @apiCallParameter

    # If EnableException an exception would have be thrown, otherwise the function returns true for success or false for failure
    if (-not $EnableException){
        return ($null -ne $result)
    }
}