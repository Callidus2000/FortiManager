function Get-FMTaskStatus {
    <#
    .SYNOPSIS
    Queries the current state of a system task.

    .DESCRIPTION
    Queries the current state of a system task.

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
        [switch]$Wait,
        [bool]$EnableException = $true
    )
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMTaskStatus"
        LoggingActionValues = @($Id)
        method              = "get"
        Path                = "/task/task/$Id"
    }

    do {
        $repeat=$false
        # if($wait){$repeat=$true}
        $result = Invoke-FMAPI @apiCallParameter
        if($wait){
            if (($result.result.data.num_done + $result.result.data.num_err) -eq 0) {
                # Still running
                $repeat=$true
            }
            elseif (($result.result.data.num_err) -gt 0) {
                Write-PSFMessage "Task-Error: $($result.result.data | ConvertTo-Json -WarningAction SilentlyContinue)"
                if($EnableException){
                    throw "Task Error"
                }
                return $result.result
            }
        }
        if ($repeat){
            Write-PSFMessage "Sleeping before repeating"
            Start-Sleep -Seconds 2
        }
    } while ($repeat    )
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
