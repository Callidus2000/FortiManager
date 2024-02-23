function Remove-FMALogSearch {
    <#
    .SYNOPSIS
    Removes a log search task from a FortiAnalyzer instance.

    .DESCRIPTION
    The Remove-FMALogSearch function removes a specific log search task from a FortiAnalyzer instance.
    It allows cleaning up log search tasks that are no longer needed.

    .PARAMETER Connection
    Specifies the connection to the FortiAnalyzer instance. If not specified, it uses the last connection
    to an Analyzer obtained by Get-FMLastConnection.

    .PARAMETER ADOM
    Specifies the administrative domain (ADOM) from which to remove the log search task.

    .PARAMETER EnableException
    Indicates whether exceptions should be enabled or not. By default, exceptions are enabled.

    .PARAMETER TaskId
    Specifies the TaskId of the log search task to remove. This parameter is mandatory.

    .EXAMPLE
    Remove-FMALogSearch -TaskId 123456

    Removes the log search task with TaskId 123456.

    .NOTES
    Author: [Author Name]
    Date: [Date]
    Version: [Version]
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection -Type Analyzer),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $true)]
        [long]$TaskId
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    Write-PSFMessage ($Parameter|convertto-json)
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Remove-FMALogSearch"
        LoggingActionValues = $TaskId
        method              = "delete"
        Path                = "/logview/adom/$explicitADOM/logsearch/$TaskId"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    # return $result.result.tid
}