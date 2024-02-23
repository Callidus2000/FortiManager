function Search-FMALog {
    <#
    .SYNOPSIS
    Starts a log search on a FortiAnalyzer instance.

    .DESCRIPTION
    The Start-FMALogSearch function initiates a log search task on a FortiAnalyzer instance. It allows searching logs
    based on specified criteria such as devices, log types, time range, etc.

    .PARAMETER Connection
    Specifies the connection to the FortiAnalyzer instance. If not specified, it uses the last connection
    to an Analyzer obtained by Get-FMLastConnection.

    .PARAMETER ADOM
    Specifies the administrative domain (ADOM) from which to initiate the log search task.

    .PARAMETER EnableException
    Indicates whether exceptions should be enabled or not. By default, exceptions are enabled.

    .PARAMETER Apiver
    Specifies the API version to use. Default is 3.

    .PARAMETER CaseSensitive
    Indicates whether the log search is case sensitive or not.

    .PARAMETER Device
    Specifies the device(s) to search logs on. Use TabExpansion attribute to provide completion for FortiAnalyzer devices.

    .PARAMETER Filter
    Specifies the filter to apply when searching logs. This is a filter string equal to the usage within the analyzer GUI

    .PARAMETER Logtype
    Specifies the type of logs to search for. Use ValidateSet attribute to choose from available log types.

    .PARAMETER TimeOrder
    Specifies the order of log search results by time. Choose from 'desc' (descending) or 'asc' (ascending).

    .PARAMETER TimeRangeStart
    Specifies the start time of the log search range. Mandatory when using the time range.

    .PARAMETER TimeRangeEnd
    Specifies the end time of the log search range. Mandatory when using the time range.

    .PARAMETER Last
    Specifies the time span from which to search logs. Mandatory when using the time span.

    .PARAMETER Timezone
    Specifies the timezone for the log search.

    .EXAMPLE
    Search-FMALog -Device "Device1" -Logtype "traffic" -TimeRangeStart (Get-Date).AddDays(-1) -TimeRangeEnd (Get-Date)

    Starts a log search task for traffic logs on "Device1" within the last 24 hours.
    .EXAMPLE
    Search-FMALog -Device "Device1" -Logtype "traffic" -Last ([timeSpan]::FromHours(5))

    Starts a log search task for traffic logs on "Device1" within the last 5 hours.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection -Type Analyzer),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [long]$Apiver = 3,
        [bool]$CaseSensitive,
        [parameter(mandatory = $true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortiAnalyzer.Devices")]
        [System.Object[]]$Device,
        [string]$Filter,
        [parameter(mandatory = $true)]
        [ValidateSet('traffic', 'app-ctrl', 'attack', 'content', 'dlp', 'emailfilter', 'event', 'history', 'virus', 'voip', 'webfilter', 'netscan', 'fct-event', 'fct-traffic', 'waf', 'gtp')]
        [string]$Logtype,
        [ValidateSet('desc', 'asc')]
        [string]$TimeOrder,
        [parameter(mandatory = $true, ParameterSetName = "timeRange")]
        [datetime]$TimeRangeStart,
        [parameter(mandatory = $true, ParameterSetName = "timeRange")]
        [datetime]$TimeRangeEnd,
        [parameter(mandatory = $true, ParameterSetName = "timeSpan")]
        [timespan]$Last,
        [string]$Timezone
    )
    $PageSize = 1000
    $searchParam = $PSBoundParameters | ConvertTo-PSFHashtable #-Exclude PageSize
    $taskId = start-fmalogsearch @searchParam
    if ($taskId -eq 0) {
        Stop-PSFFunction -Level Critical -Message "Could not obtain a taskId/start the logsearch"
        return
    }
    $Parameter = @{
        'apiver' = $Apiver
        "limit"  = $PageSize
        "offset" = 0
    } | Remove-FMNullValuesFromHashtable -NullHandler "RemoveAttribute"
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    Write-PSFMessage ($Parameter | convertto-json)
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMALogSearchResults"
        LoggingActionValues = @($Parameter.limit, $Parameter.offset)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/logview/adom/$explicitADOM/logsearch/$taskId"
        LoggingLevel        = "Verbose"
    }
    # $dataCollector=[System.Collections.ArrayList]::new()
    $dataCollector = @()
    do {
        $currentStatus = Get-FMALogSearchStatus -TaskId $taskId -Connection $Connection -Adom $ADOM -LoggingLevel Verbose
        if ($currentStatus.status -and $currentStatus.status.code -ne 0) {
            Stop-PSFFunction -Level Critical -Message "Error while querying the current logsearch status, $($currentStatus.status|ConvertTo-Json -Compress)"
            return
        }

        if ([string]::IsNullOrEmpty($currentStatus)) {
            Stop-PSFFunction -Level Critical -Message "No current count status available for taskId $taskId" -EnableException $EnableException
            return
        }
        $secondsRemaining = ($currentStatus."estimated-remain-sec" + 1)
        Write-Progress -Activity "Waiting for logsearch to be finished" -SecondsRemaining $secondsRemaining
        Write-PSFMessage "`$currentStatus=$($currentStatus|ConvertTo-Json -Compress)"
        Start-Sleep -Seconds $secondsRemaining
    }while ($currentStatus."progress-percent" -ne 100 )
    $maxRows = $currentStatus."matched-logs"
    $collectedRecords = 0
    $i = 0
    do {
        $i++
        $remainingRecords = $maxRows - $dataCollector.Count
        if ($remainingRecords -lt $apiCallParameter.Parameter.limit) {
            $apiCallParameter.Parameter.limit = $remainingRecords
        }
        $percentCompleted = [int]($dataCollector.Count / $maxRows * 100)
        Write-Progress -Activity "Getting logdata" -PercentComplete $percentCompleted -Status "$percentCompleted% completed, $($dataCollector.Count) rows fetched"
        $retryCount = 0
        do {
            $response = Invoke-FMAPI @apiCallParameter #-Verbose
            if ($response.result."return-lines" -eq 0) {
                $retryCount++
                if ($response.result."return-lines" -gt 15) {Start-Sleep -Seconds 1}
            }
        }until($response.result."return-lines" -gt 0 -or $retryCount -gt 40)
        if ($retryCount -gt 0) {
            Write-PSFMessage "Needed $retryCount retries before the API provided data" -Level Debug
        }
        if ($retryCount -gt 40) {
            Stop-PSFFunction -Message "Needed $retryCount retries before the API provided data" -Level Error
            return
        }
        $collectedRecords += $response.result."return-lines"
        $dataCollector += $response.result.data
        $Parameter.Offset = $dataCollector.Count
        $apiCallParameter.LoggingActionValues = @($Parameter.limit, $Parameter.offset)
    }while (($dataCollector.Count -lt $maxRows) -and ($response.result.data.Count -gt 0) -and ($collectedRecords -lt $maxRows))
    return $dataCollector
}