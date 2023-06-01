function Get-FMFirewallHitCount {
    <#
    .SYNOPSIS
    Queries hitcounts for a firewall policy.

    .DESCRIPTION
    Queries hitcounts for a firewall policy.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Package
    The name of the policy package

    .PARAMETER Force
    If set, the hitcounts will be refreshed before query.

    .EXAMPLE
    $hitCountData=Get-FMFirewallHitCount -Package $packageName
    Write-Host "`$hitCountData.count=$($hitCountData."firewall policy".count)"

    Gets the hitcounts for the firewall policy
    .NOTES
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Package,
        [switch]$Force
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $packageInfo = Get-FMPolicyPackage -Connection $Connection  -Adom $explicitADOM -Name $Package
    if ($Force -or $packageInfo."package settings"."hitc-taskid" -eq 0) {
        Write-PSFMessage -Level Host "Refresh hitcounts"
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Get-FMFirewallHitCount"
            LoggingActionValues = @($explicitADOM, $Package)
            method              = "exec"
            Parameter           = @{
                data = @{
                    adom = "$explicitADOM"
                    pkg  = "$Package"
                }
            }
            Path                = "/sys/hitcount"
        }
        $initTaskResult = Invoke-FMAPI @apiCallParameter
        $taskID = $initTaskResult.result[0].taskid
        Write-PSFMessage "taskID=$taskID"
        $taskStatus = Get-FMTaskStatus -Id $taskID -Wait -Verbose
        Write-PSFMessage "Status of Task $($taskID): $($taskStatus| ConvertTo-Json -WarningAction SilentlyContinue -Depth 3)"
    }
    else {
        $taskID = $packageInfo."package settings"."hitc-taskid"
        (Get-Date 01.01.1970) + ([System.TimeSpan]::fromseconds(1655983275))
        $timestamp = $packageInfo."package settings"."hitc-timestamp" | Convert-FMTimestampToDate
        Write-PSFMessage -Level Host "Query existing hitcounts from $timestamp"
    }
    $result = Get-FMTaskResult -Id $taskID -verbose
    return $result
}
