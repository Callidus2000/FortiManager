function Start-FMALogSearch {
    <#
    .SYNOPSIS
    Starts a log search task on a FortiAnalyzer instance.

    .DESCRIPTION
    The Start-FMALogSearch function initiates a log search task on a FortiAnalyzer instance. It allows searching logs
    based on specified criteria such as devices, log types, time range, etc.
    If successful the function returns the taskId of the logsearch, otherwise 0

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
    Start-FMALogSearch -Device "Device1" -Logtype "traffic" -TimeRangeStart (Get-Date).AddDays(-1) -TimeRangeEnd (Get-Date)

    Starts a log search task for traffic logs on "Device1" within the last 24 hours.
    .EXAMPLE
    Start-FMALogSearch -Device "Device1" -Logtype "traffic" -Last ([timeSpan]::FromHours(5))

    Starts a log search task for traffic logs on "Device1" within the last 5 hours.
    #>
    [CmdletBinding()]
    [OutputType([int])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
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
    if ($Last) {
        $TimeRangeEnd = Get-Date
        $TimeRangeStart = $TimeRangeEnd - $Last
    }
    $Parameter = @{
        'apiver'         = $Apiver
        'device'         = [array]($Device | ForEach-Object { @{devname = $_ } })
        'filter'         = "$Filter"
        'logtype'        = "$Logtype"
        'time-order'     = "$TimeOrder"
        'timezone'       = "$Timezone"
        'case-sensitive' = $CaseSensitive
        'time-range'     = @{
            start = $TimeRangeStart.ToString("yyyy-MM-dd'T'HH:mm:ssz")
            end   = $TimeRangeEnd.ToString("yyyy-MM-dd'T'HH:mm:ssz")
        }
    } | Remove-FMNullValuesFromHashtable -NullHandler "RemoveAttribute"
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    Write-PSFMessage ($Parameter | convertto-json)
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Start-FMALogSearch"
        LoggingActionValues = @(($Device | join-string -Separator ','), $Filter)
        method              = "add"
        Parameter           = $Parameter
        Path                = "/logview/adom/$explicitADOM/logsearch"
    }
    $result = Invoke-FMAPI @apiCallParameter
    if ($result.result.status -and $result.result.status.code -ne 0) {
        Stop-PSFFunction -Level Critical -Message "Could not obtain a taskId/start the logsearch, $($result.result.status|ConvertTo-Json -Compress)"
        return 0
    }
    Write-PSFMessage "Result-Status:  $($result.result.status)"
    Write-PSFMessage "Search Task-ID: $($result.result.tid)"
    return $result.result.tid
}