function Move-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Adds new firewall policies to the given ADOM and policy package.

    .DESCRIPTION
    Adds new firewall policies to the given ADOM and policy package. This
    function adds the policy to the End of the Package. If you need it elsewhere
    you have to use ""

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER PolicyID
    The ID of the policy to be moved

    .PARAMETER Position
    Before or After

    .PARAMETER Target
    The Policy-ID the policies should be moved before/after

    .EXAMPLE
    Lock-FMAdom -Connection $connection
    try {
        #Get all Policies Which contains "Test"
        $allTestPolicies = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %Test%" -Fields policyid
        # move all but the first one after the first one
        $allTestPolicies | Select-Object -skip 1 | Move-FMFirewallPolicy -Package $packageName -position after -Target ($allTestPolicies | Select-Object -First 1)
        Publish-FMAdomChange -Connection $connection
    }
    catch {
        Write-Host  "Error $_"
    }
    finally {
        UnLock-FMAdom -Connection $connection
    }

    Reorders the Test policies
    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true)]
        [string]$Package,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Object[]]$PolicyID,
        [parameter(mandatory = $true, ValueFromPipeline = $false)]
        $Target,
        [parameter(mandatory = $true, ValueFromPipeline = $false)]
        [ValidateSet("before", "after")]
        [string]$Position,
        [bool]$EnableException = $true
    )
    begin {
        $policyList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        if ($Target -isnot [long]) {
            $Target = $Target.policyid
        }
    }
    process {
        $PolicyID | ForEach-Object {
            $id=$_
            if ($id -isnot [long]) {
                $id = $id.policyid
            }
            write-psfmessage "Adding To List: $id"
            $policyList += $id
        }
    }
    end {
        $basePath = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy"
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Move-FMFirewallPolicy"
            LoggingActionValues = @(0, $Position, $Target, $explicitADOM, $Package)
            method              = "move"
            Parameter           = @{
                target = "$Target"
                option = $Position
            }
        }
        foreach ($id in $policyList) {
            write-psfmessage "Moving ID $id"
            $apiCallParameter.Path = "$basePath/$id"
            $apiCallParameter.LoggingActionValues[0] = $id
            Write-PSFMessage "`$apiCallParameter.LoggingActionValues=$($apiCallParameter.LoggingActionValues | join ';')"
            $result = Invoke-FMAPI @apiCallParameter
            if (-not $EnableException -and $null -ne $result) {
                return $false
            }
        }
        if (-not $EnableException) {
            return $false
        }
    }
}
