﻿function Add-FMAddressGroup {
    <#
    .SYNOPSIS
    Adds new address groups to the given ADOM.

    .DESCRIPTION
    Adds new address groups to the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER AddressGroup
    The new address group, generated e.g. by using New-FMObjAddressGroup

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .PARAMETER Overwrite
    If used and an address with the given name already exists the data will be overwritten.

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$AddressGroup,
        [switch]$Overwrite,
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $groupList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallAddressGroups'
    }
    process {
        $AddressGroup | ForEach-Object { $groupList += $_ | ConvertTo-PSFHashtable -Include $validAttributes }
    }
    end {
        $apiCallParameter = @{
            RevisionNote        = $RevisionNote
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMAddressGroup"
            LoggingActionValues = @($groupList.count, $explicitADOM)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp"
            Parameter           = @{
                "data" = $groupList
            }
        }
        if ($Overwrite) {
            Write-PSFMessage "Existing data should be overwritten"
            $apiCallParameter.method = "set"
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}