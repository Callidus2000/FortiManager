﻿function Update-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Adds new firewall policies to the given ADOM and policy package.

    .DESCRIPTION
    Adds new firewall policies to the given ADOM and policy package.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER Policy
    The new policy, generated e.g. by using New-FMObjAddress

    .PARAMETER PolicyID
    The ID of the policies to be modified with the Attribute values

    .PARAMETER Attribute
    The attributes to be modified for the policies with the IDs of the parameter PolicyID

    .PARAMETER Overwrite
    If used and an policy with the given name already exists the data will be overwritten.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Update-FMFirewallPolicy -Connection $Connection -Adom $explicitADOM -Package $Package -PolicyId 4711 -Attribute @{status = 'disable'}

    Sets the status attribute of the policy 4711 to disable

    .EXAMPLE
    $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
    $policy.service = "HTTP"
    $policy | Update-FMFirewallPolicy -Package $packageName

    Updates the service of the queried policy rule.

    Later
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [parameter(mandatory = $true, ParameterSetName = "multiUpdate")]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortigateManager.FirewallPackage")]
        [string]$Package,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Policy,
        [parameter(mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "multiUpdate")]
        [Int64[]]$PolicyID,
        [parameter(mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "multiUpdate")]
        [hashtable]$Attribute,
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $policyList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallPolicy'
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'multiUpdate' {  }
            Default {
                $Policy | ForEach-Object {
                    $policyList += $_ | ConvertTo-PSFHashtable -Include $validAttributes
                }
            }
        }
    }
    end {
        switch ($PSCmdlet.ParameterSetName) {
            'multiUpdate' {
                Write-PSFMessage "Update $($PolicyID.count) Policies with $($Attribute.count) new attributes"
                $Attribute = $Attribute | ConvertTo-PSFHashtable -Include $validAttributes
                $apiCallParameter = @{
                    EnableException     = $EnableException
                    RevisionNote        = $RevisionNote
                    Connection          = $Connection
                    LoggingAction       = "Update-FMFirewallPolicy"
                    LoggingActionValues = @($PolicyID.count, $explicitADOM, $Package)
                    method              = "update"
                    Parameter           = @()
                }
                foreach ($polId in $PolicyID) {
                    $apiCallParameter.Parameter += @{
                        url          = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy/$polId"
                        RevisionNote = $RevisionNote
                        data         = $Attribute
                    }
                }

                $result = Invoke-FMAPI @apiCallParameter
            }
            Default {
                $apiCallParameter = @{
                    EnableException     = $EnableException
                    RevisionNote        = $RevisionNote
                    Connection          = $Connection
                    LoggingAction       = "Update-FMFirewallPolicy"
                    LoggingActionValues = @($policyList.count, $explicitADOM, $Package)
                    method              = "update"
                    Path                = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy"
                    Parameter           = @{
                        "data" = $policyList
                    }
                }
                $result = Invoke-FMAPI @apiCallParameter
            }
        }
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}