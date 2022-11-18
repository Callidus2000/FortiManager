function Add-FMAdomRevision {
    <#
    .SYNOPSIS
    Creates a new revision of the given ADOM.

    .DESCRIPTION
    Creates a new revision of the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    Name of the revision, mandatory

    .PARAMETER Desc
    Description of the revision

    .PARAMETER Locked
    Should the revision be protected against deletion?

    .PARAMETER NullHandler
    Parameter description


    .PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Add-FMAdomRevision -Name "Prior multiple deletion"

    Creates the new revision.

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Desc,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [switch]$Locked,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute",
        [bool]$EnableException = $true
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
    Write-PSFMessage "`$explicitADOM=$explicitADOM"
    $apiCallParameter = @{
        EnableException     = $EnableException
        RevisionNote        = $RevisionNote
        Connection          = $Connection
        LoggingAction       = "Add-FMAdomRevision"
        LoggingActionValues = @($explicitADOM)
        method              = "add"
        Path                = "/dvmdb/adom/$explicitADOM/revision"
        Parameter           = @{
            data = @{
                'created_by' = $connection.AuthenticatedUser
                'desc'       = "$Desc"
                'locked'     = 0
                'name'       = "$Name"
            } | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
        }
    }
    if ($Locked) { $apiCallParameter.Parameter.data.locked = 1 }
    $result = Invoke-FMAPI @apiCallParameter
    if (-not $EnableException) {
        return ($null -ne $result)
    }
}