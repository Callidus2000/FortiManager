function Start-FMALogSearch {
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
    if($Last){
        $TimeRangeEnd=Get-Date
        $TimeRangeStart = $TimeRangeEnd - $Last
    }
    $Parameter = @{
        'apiver'     = $Apiver
        'device'     = [array]($Device | ForEach-Object { @{devname =$_}})
        'filter'     = "$Filter"
        'logtype'    = "$Logtype"
        'time-order' = "$TimeOrder"
        'timezone'   = "$Timezone"
        'time-range' = @{
            start = $TimeRangeStart.ToString("yyyy-MM-dd'T'HH:mm:ssz")
            end   = $TimeRangeEnd.ToString("yyyy-MM-dd'T'HH:mm:ssz")
        }
    } | Remove-FMNullValuesFromHashtable -NullHandler "RemoveAttribute"
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    Write-PSFMessage ($Parameter|convertto-json)
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Start-FMALogSearch"
        LoggingActionValues = @(($Device|join-string -Separator ','),$Filter)
        method              = "add"
        Parameter           = $Parameter
        Path                = "/logview/adom/$explicitADOM/logsearch"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.tid
}