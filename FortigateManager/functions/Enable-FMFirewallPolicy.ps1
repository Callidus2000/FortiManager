function Enable-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Enables specific firewall policies in the given ADOM and policy package.

    .DESCRIPTION
    Enables specific firewall policies in the given ADOM and policy package.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER PolicyID
    The policyid attribut of the policy to modify.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Enable-FMFirewallPolicy  -Package $packageName -PolicyID 4711,4712

    Enables the two policies.

    .EXAMPLE
    4711,4712 | Enable-FMFirewallPolicy  -Package $packageName

    Enables the two policies.

    .EXAMPLE
    $newPolicies = Get-FMFirewallPolicy -Package $packageName -Filter "name -like PESTER policy B-%$pesterGUID"
    $newPolicies | Enable-FMFirewallPolicy -Package $packageName

    Enables the returned policies.
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "multiUpdate")]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortigateManager.FirewallPackage")]
        [string]$Package,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "multiUpdate")]
        [Int64[]]$PolicyID,
        [bool]$EnableException = $true
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        $attributesToModify = @{status = 'enable' }
        $policyIdList = @()
    }
    process {
        $PolicyID | ForEach-Object {
            $policyIdList += $_
        }
    }
    end {
        Write-PSFMessage "Enabling Policies $($policyIdList|Join-String ',')"
        return Update-FMFirewallPolicy -Connection $Connection -Adom $explicitADOM -Package $Package -PolicyId $policyIdList -Attribute $attributesToModify -EnableException $EnableException
    }
}