﻿function Disable-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Disables specific firewall policies in the given ADOM and policy package.

    .DESCRIPTION
    Disables specific firewall policies in the given ADOM and policy package.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER PolicyID
    The policyid attribut of the policy to modify.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Disable-FMFirewallPolicy  -Package $packageName -PolicyID 4711,4712

    Disables the two policies.

    .EXAMPLE
    4711,4712 | Disable-FMFirewallPolicy  -Package $packageName

    Disables the two policies.

    .EXAMPLE
    $newPolicies = Get-FMFirewallPolicy -Package $packageName -Filter "name -like PESTER policy B-%$pesterGUID"
    $newPolicies | Disable-FMFirewallPolicy -Package $packageName

    Disables the returned policies.
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
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        $attributesToModify = @{status = 'disable' }
        $policyIdList = @()
    }
    process {
        $PolicyID | ForEach-Object {
                $policyIdList += $_
        }
    }
    end {
        Write-PSFMessage "Disabling Policies $($policyIdList|Join-String ',')"
        return Update-FMFirewallPolicy -Connection $Connection -Adom $explicitADOM -Package $Package -PolicyId $policyIdList -Attribute $attributesToModify -EnableException $EnableException -RevisionNote $RevisionNote
    }
}