function Remove-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Removes a firewall policy by policyId.

    .DESCRIPTION
    Removes a firewall policy by policyId.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER PolicyId
    Id of the Policy to be removed.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testAddresses = Get-FMAddress -Connection $Connection -Filter "comment -like %API Test%" |select -first 3
    Lock-FMAdom -Connection $connection
    try {
        $testAddresses | remove-fmaddress -connection $connection
        Publish-FMAdomChange -Connection $connection
    }
    catch {
        Write-PSFMessage -Level Warning "$_"
    }
    finally {
        UnLock-FMAdom -Connection $connection
    }

    Query addresses by comment and removes them
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Package,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [long[]]$PolicyId
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Remove-FMFirewallPolicy"
            LoggingActionValues = $explicitADOM
            method              = "delete"
        }
        $policyIdList = @()
    }
    process {
        $policyIdList += $PolicyId #-replace '/', '\/'
    }
    end {
        # Removing potential Null values
        $policyIdList = $policyIdList | Where-Object { $_ }
        foreach ($id in $policyIdList) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy/$id"
            $apiCallParameter.LoggingActionValues = $id
            $result = Invoke-FMAPI @apiCallParameter
            $result|Out-Null
        }
    }
}