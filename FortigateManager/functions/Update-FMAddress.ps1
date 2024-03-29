﻿function Update-FMAddress {
    <#
    .SYNOPSIS
    Updates an existing addresses.

    .DESCRIPTION
    Updates an existing addresses.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address to be changed (neccessary if the 'name' property itself changes)
    This is the *old* Name of the existing object! The new name has to be set in the object itself.

    .PARAMETER Address
    The new address, generated e.g. by using New-FMObjAddress or Get-FMAddress

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testAddress=Get-FMAddress -filter "name -eq MyDUMMY" -verbose
    $testAddress.comment="Modified at $(Get-Date)"
    $testAddress | Update-fmaddress

    Sets the comment field (must exist or you need to have e.g. Add-Member.)

    .EXAMPLE
    $testAddress=Get-FMAddress -filter "name -eq MyDUMMY" -verbose
    $testAddress.name="MyDUMMY 2"
    Update-fmaddress -Address $testAddress -Name "MyDUMMY"

    Renames the address "MyDUMMY" to "MyDUMMY 2"

    .EXAMPLE
    Update-fmaddress -Address @{name="MyDUMMY 2"} -Name "MyDUMMY"

    Renames the address "MyDUMMY" to "MyDUMMY 2", everything else will be kept unchanged.

    .NOTES
    If an address object does not contain every attribute which is already set,
    then the existing values will be kept.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Address,
        [string]$Name,
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $addressList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallAddress'
    }
    process {
        $Address | ForEach-Object { $addressList += $_ | ConvertTo-PSFHashtable -Include $validAttributes }
    }
    end {
        if ($addressList.count -gt 1 -and $Name) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "Usage of -Name and more than one -Address is not permitted"
            return
        }
        $apiCallParameter = @{
            EnableException     = $EnableException
            RevisionNote        = $RevisionNote
            Connection          = $Connection
            LoggingAction       = "Update-FMAddress"
            LoggingActionValues = @($addressList.count, $explicitADOM, $Name)
            method              = "update"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/address"
            Parameter           = @{
                "data" = $addressList
            }
        }
        if ($Name) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/address/$($Name|ConvertTo-FMUrlPart)"
            # if name is given 'data' does only accept one object but no array
            $apiCallParameter.Parameter.data = $addressList[0]
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}