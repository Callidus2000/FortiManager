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

    .PARAMETER Fields
    Which log attributes should be returned?

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
    [OutputType([object[]])]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection -Type Analyzer),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [long]$Apiver = 3,
        [bool]$CaseSensitive=$false,
        [parameter(mandatory = $false)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortiAnalyzer.Devices")]
        [System.Object[]]$Device,
        [string]$Filter,
        [parameter(mandatory = $true)]
        [ValidateSet('traffic', 'app-ctrl', 'attack', 'content', 'dlp', 'emailfilter', 'event', 'history', 'virus', 'voip', 'webfilter', 'netscan', 'fct-event', 'fct-traffic', 'waf', 'gtp')]
        [string]$Logtype,
        [ValidateSet('desc', 'asc')]
        [string]$TimeOrder,
        [parameter(mandatory = $true, ParameterSetName = "timeRange")]
        [parameter(mandatory = $true, ParameterSetName = "timeSpanFromStart")]
        [parameter(mandatory = $true, ParameterSetName = "MaxLogCountFromStart")]
        [datetime]$TimeRangeStart,
        [parameter(mandatory = $true, ParameterSetName = "timeRange")]
        [parameter(mandatory = $true, ParameterSetName = "timeSpanUntilEnd")]
        [parameter(mandatory = $true, ParameterSetName = "MaxLogCountUntilEnd")]
        [datetime]$TimeRangeEnd,
        [parameter(mandatory = $true, ParameterSetName = "timeSpanUntilEnd")]
        [parameter(mandatory = $true, ParameterSetName = "timeSpanFromStart")]
        [parameter(mandatory = $true, ParameterSetName = "timeSpan")]
        [timespan]$Last,
        [parameter(mandatory = $true, ParameterSetName = "MaxLogCountUntilEnd")]
        [parameter(mandatory = $true, ParameterSetName = "MaxLogCountFromStart")]
        [parameter(mandatory = $true, ParameterSetName = "MaxLogCount")]
        [long]$TargetLogCount,
        [string]$Timezone,
        [ValidateSet('date', 'time', 'id', 'itime', 'euid', 'epid', 'dsteuid', 'dstepid', 'logflag', 'logver', 'type', 'subtype', 'level', 'action', 'policyid', 'sessionid', 'srcip', 'dstip', 'srcport', 'dstport', 'trandisp', 'duration', 'proto', 'sentbyte', 'rcvdbyte', 'sentpkt', 'rcvdpkt', 'logid', 'service', 'app', 'appcat', 'srcintfrole', 'dstintfrole', 'srcserver', 'dstserver', 'policytype', 'eventtime', 'poluuid', 'srcmac', 'mastersrcmac', 'dstmac', 'masterdstmac', 'srchwvendor', 'srcswversion', 'dsthwvendor', 'dstswversion', 'devtype', 'osname', 'dstosname', 'srccountry', 'dstcountry', 'srcintf', 'dstintf', 'policyname', 'tz', 'devid', 'vd', 'dtime', 'itime_t', 'devname')]
        [string[]]$Fields,
        [long]$MaxLogEntries=[long]::MaxValue
    )
    $PageSize = 1000
    # if ($PSCmdlet.ParameterSetName -eq )
    $searchParam = $PSBoundParameters | ConvertTo-PSFHashtable -Exclude Fields, TargetLogCount, Last, MaxLogEntries
    $searchParam.TimeOrder='desc'
    if ($PSCmdlet.ParameterSetName -ne 'timeRange'){
        $tempHash = $PSBoundParameters | ConvertTo-PSFHashtable -Include TimeRangeStart, TimeRangeEnd, TargetLogCount, Last -IncludeEmpty
        $tempHash.last = $tempHash.last.ToString("g")
        Write-PSFMessage "Calculate TimeRangeStart and TimeRangeEnd from $($tempHash|ConvertTo-Json -Compress)"
    }
    switch -regex ($PSCmdlet.ParameterSetName){
        'timeSpan$'{
            $searchParam.TimeRangeEnd = Get-Date
            $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $Last
        }
        'timeSpanUntilEnd' {
            $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $Last
        }
        'timeSpanFromStart' {
            $searchParam.TimeRangeEnd = $searchParam.TimeRangeStart + $Last
        }
        'MaxLogCount' {
            $searchWindowDuration = Get-PSFConfigValue -FullName 'FortigateManager.Search.DefaultMaxRowDuration'
            If ($MaxLogEntries -eq [long]::MaxValue) {
                $MaxLogEntries = [long]($TargetLogCount*1.1)
                Write-PSFMessage "Adjusting MaxLogEntries from Max([long]) to TargetLogCount plus 10% (=$MaxLogEntries)" -Level Host
            }
        }
        'MaxLogCount$' {
            $searchParam.TimeRangeEnd = Get-Date
            $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $searchWindowDuration
        }
        'MaxLogCountUntilEnd' {
            $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $searchWindowDuration
        }
        'MaxLogCountFromStart' {
            $searchParam.TimeRangeEnd = Get-Date
            $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $searchWindowDuration
        }
    }
    if ($PSCmdlet.ParameterSetName -match 'MaxLogCount') {
        Write-PSFMessage "Performing initial search for duration of $searchWindowDuration"
        $taskId = start-fmalogsearch @searchParam
         if($taskId -eq 0) {
            Stop-PSFFunction -Level Critical -Message "Could not obtain a taskId/start the logsearch"
            return
        }
        $currentStatus = Get-FMALogSearchStatus -TaskId $taskId -Connection $Connection -Adom $ADOM -LoggingLevel Verbose -Wait
        Remove-FMALogSearch -TaskId $taskId
        # Applying the Rule of three
        $matchedLogs = $currentStatus."matched-logs"
        if ($matchedLogs -eq 0){
            Write-PSFMessage "Found 0 logs in timespan $($searchWindowDuration.ToString('g')), cannot auto adjust" -Level Warning
            return
        }
        $timeMultiplier=$TargetLogCount/$matchedLogs
        $usedDurationInSeconds = $searchWindowDuration.TotalSeconds
        $neededSeconds = $usedDurationInSeconds * $timeMultiplier
        $newSearchWindowDuration=[timespan]::FromSeconds([long]$neededSeconds)
        Write-PSFMessage "Found $matchedLogs logs in timespan $($searchWindowDuration.ToString('g')), Esteminated $($newSearchWindowDuration.ToString('g')) needed for gathering $TargetLogCount logs"
        switch -regex ($PSCmdlet.ParameterSetName) {
            'MaxLogCount$' {
                $searchParam.TimeRangeEnd = Get-Date
                $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $newSearchWindowDuration
            }
            'MaxLogCountUntilEnd' {
                $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $newSearchWindowDuration
            }
            'MaxLogCountFromStart' {
                $searchParam.TimeRangeEnd = Get-Date
                $searchParam.TimeRangeStart = $searchParam.TimeRangeEnd - $newSearchWindowDuration
            }
        }
    }
    if ($PSCmdlet.ParameterSetName -ne 'timeRange') {
        Write-PSFMessage "Result of calculation: $($searchParam | ConvertTo-PSFHashtable -Include TimeRangeStart,TimeRangeEnd|ConvertTo-Json -Compress)"
    }
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
    $dataCollector=[System.Collections.ArrayList]::new()
    # $dataCollector = @()
    $retryCount=Get-PSFConfigValue -FullName 'FortigateManager.Analyzer.RetryCountForStatus' -Fallback 4
    $currentStatus = Get-FMALogSearchStatus -TaskId $taskId -Connection $Connection -Adom $ADOM -LoggingLevel Verbose -Wait

    $maxRows = $currentStatus."matched-logs"
    if ($maxRows -eq 0){
        Write-PSFMessage -Level Warning -Message "Search did not return any data"
        return
    }
    Write-PSFMessage -Level Host -Message "Fetching $maxRows rows of data"
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
                if ($retryCount -gt 15) { Start-Sleep -Seconds 1}
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
        if($Fields){
            [void]$dataCollector.AddRange(([array]($response.result.data | Select-Object -Property $Fields)))
        }else{
            [void]$dataCollector.AddRange(([array]($response.result.data)))
        }
        # $dataCollector += $response.result.data
        $Parameter.Offset = $dataCollector.Count
        $apiCallParameter.LoggingActionValues = @($Parameter.limit, $Parameter.offset)
    }while (($dataCollector.Count -lt $maxRows) -and ($response.result.data.Count -gt 0) -and ($collectedRecords -lt $maxRows) -and ($dataCollector.Count -lt $MaxLogEntries))
    if ($dataCollector.Count -gt $MaxLogEntries) { Write-PSFMessage -Level Warning "Stopped at $($dataCollector.Count) logs as only $MaxLogEntries should have been retrieved"}
    Remove-FMALogSearch -TaskId $taskId
    return $dataCollector.ToArray()
}