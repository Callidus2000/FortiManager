function Get-FMALogSearchStatus {
    <#
    .SYNOPSIS
    Retrieves the status of a log search task from a FortiAnalyzer instance.

    .DESCRIPTION
    The Get-FMALogSearchStatus function retrieves the status of a log search task from a FortiAnalyzer instance.
    It allows checking the status of a specific log search task identified by its TaskId.

    .PARAMETER Connection
    Specifies the connection to the FortiAnalyzer instance. If not specified, it uses the last connection
    to an Analyzer obtained by Get-FMLastConnection.

    .PARAMETER ADOM
    Specifies the administrative domain (ADOM) from which to retrieve log search status.

    .PARAMETER EnableException
    Indicates whether exceptions should be enabled or not. By default, exceptions are enabled.

    .PARAMETER TaskId
    Specifies the TaskId of the log search task to retrieve the status for. This parameter is mandatory.

    .EXAMPLE
    Get-FMALogSearchStatus -TaskId 123456

    Retrieves the status of the log search task with TaskId 123456.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection -Type Analyzer),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $true)]
        [long]$TaskId
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $parameter=@{
        apiver=3
    }
    # Write-PSFMessage ($Parameter|convertto-json)
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMALogSearchStatus"
        LoggingActionValues = $TaskId
        method              = "get"
        Path                = "/logview/adom/$explicitADOM/logsearch/count/$TaskId"
        Parameter           = $parameter
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result
}