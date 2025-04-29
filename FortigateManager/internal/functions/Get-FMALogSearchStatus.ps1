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

    .PARAMETER LoggingLevel
    On which level should die diagnostic Messages be logged?
    Defaults to PSFConfig "FortigateManager.Logging.Api"

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
        [long]$TaskId,
        [ValidateSet("Critical", "Important", "Output", "Host", "Significant", "VeryVerbose", "Verbose", "SomewhatVerbose", "System", "Debug", "InternalComment", "Warning")]
        [string]$LoggingLevel = (Get-PSFConfigValue -FullName "FortigateManager.Logging.Api" -Fallback "Verbose"),
        [switch]$Wait
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
        LoggingLevel        = $LoggingLevel
        RetryCountOnEmptyResult = (Get-PSFConfigValue -FullName 'FortigateManager.Analyzer.RetryCountForStatus')
        RetryWaitOnEmptyResult  = (Get-PSFConfigValue -FullName 'FortigateManager.Analyzer.RetryWaitForStatus')
    }
    do {
        $result = Invoke-FMAPI @apiCallParameter
        $currentStatus = $result.result
        if ($currentStatus.status -and $currentStatus.status.code -ne 0) {
            Stop-PSFFunction -Level Critical -Message "Error while querying the current logsearch status, $($currentStatus.status|ConvertTo-Json -Compress)"
            return
        }

        if ([string]::IsNullOrEmpty($currentStatus)) {
            Stop-PSFFunction -Level Critical -Message "No current count status available for taskId $taskId, `$EnableException=$EnableException" -EnableException $EnableException
            Write-PSFMessage "Returnin PreviousStatus" -Level Host
            return $previousStatus
        }
        $secondsRemaining = ($currentStatus."estimated-remain-sec" + 1)
        Write-PSFMessage "`$currentStatus=$($currentStatus|ConvertTo-Json -Compress)"
        Write-Progress -Activity "Waiting for logsearch to be finished" -SecondsRemaining $secondsRemaining
        Start-Sleep -Seconds $secondsRemaining
        $previousStatus=$currentStatus
    }while ($currentStatus."progress-percent" -ne 100 -and $Wait )
    Write-PSFMessage "Result-Status: $($currentStatus.status)"
    return $currentStatus
}