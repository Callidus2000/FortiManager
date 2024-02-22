function Remove-FMALogSearch {
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