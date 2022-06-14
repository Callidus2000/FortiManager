function Get-FMTaskResult {
    <#
    .SYNOPSIS
    Queries the results from a prior executed task.

    .DESCRIPTION
    Queries the results from a prior executed task.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER Id
    The Task-ID

    .PARAMETER Wait
    If set then the task status will be queried until finished/failed.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .EXAMPLE
    An example

    may be provided later

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [parameter(mandatory = $true)]
        [string]$Id,
        [bool]$EnableException = $true
    )
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMTaskResult"
        LoggingActionValues = @($Id)
        method              = "exec"
        Parameter           = @{
            data=@{
                taskid = $Id
            }
        }
        Path                = "/sys/task/result"
    }
    $result = Invoke-FMAPI @apiCallParameter
    return $result.result[0].data
}
